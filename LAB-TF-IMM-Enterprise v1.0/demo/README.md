# This Demo creates a Pod (multiple IMM Domains) in Intersight using Terraform locally installed.

This terraform code for Intersight easily scales to create multiple IMM domains and Server Templates.
# https://github.com/bywhite/tf-imm-lab-basic
It was designed to enable IaC Enterprise operations for Intersight.

This demo code is a simplified version of the example code located at:
    https://github.com/bywhite/cen-iac-imm-dev-pod1
which calls the modules located at:
    https://github.com/bywhite/cen-iac-imm-dev-pod1-mods
based initially on Patrick's module:  https://github.com/pl247/tf-intersight-policy-bundle
and quality advice from Tyson.

This code is intended to run locally on a workstation with Terraform installed as a demo.
Links to the more advanced TFCB & Github deployment method is avaialble above.

The code is broken into "pod1" (intended for operations team use) and "modules" maintained by architects.
    The code creates Pools, Domain Profiles, Server Profile Templates and supporting policies.
    Operations would still be responsible for deriving Server Profiles and associating profiles to hardware.
The config files are in "pod1" and are intended to simplify the ops team's IMM-UCS deplooyment tasks.
    The config files only contain the bare minimum variables needed for customization of deployments.
    Config variables required are determined by architects while defaults are embedded in modules by architects.
    All that is needed to scale the environment is to duplicate a config file and change 3 variables.
    The config files do not require proficiency with TF or Intersight - only copy & paste and UCS Server know-how.
The "modules" are the architetural standards that implement the "resource" calls with the IMM Provider to TF.
    Architects embed their standard config's into the modules, exposing module variables for any settings they
    wish to expose to the operations team for customization via the config file's.
    The "modules" require a good understanding of Terraform, the Intersight Provider and UCS Management.
    In an Enterprise deployment, Terraform Cloud for Business along with a repo that supports versioning is 
    recommended to provide governance of changes. Repo versioning allows granular implementation of architectural changes by enforcing module versions in the calling config file.  Versioning is not available in this local demo.

The general flow of the code is:
    pod-common are created first, pools are based on the Pod ID for uniqueness and can be varied in size. 
    pod-domain create the policies and profiles needed for FI domains and their respective chassis.
    pod-srv-template creates server profile templates based common customization options.

All that is required to create a new domain is to copy pod-domain-vmw-1.tf to a new file name and change 3 identifiers at the top of the pod-domain-<new_name> module.  
    Example: replace instances of "vmw_1" with <new_name> "vmw_2"
        intersight_policy_bundle_vmw_1     with    intersight_policy_bundle_vmw_2        (module name)
        ofl-dev-pod1-vmw1                  with    ofl-dev-pod1-vmw2                     (policy prefix)
        ofl-dev-pod1-vmw1                  with    ofl-dev-pod1-vmw2                     (tag value)

# NOTE:
The demo code should run "as-is" after setting varibles found in the ~/demo/pod1/variables.tf file
    Variables required to run code:  apikey, secretkey, and organization


### Directions

1. Install Terraform on your local workstation to run the demo code.
    # https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli


2. Copy the latest version of the demo folder from within the tf-imm-lab-basic repo onto your local workstation.  You will need internet access to init Terraform and pull down the Intersight Provider for Terraform, as well as perform outgoing calls to Intersight.
    # https://github.com/bywhite/tf-imm-lab-basic


3. Create a new organization "demo-tf" in your Intersight.com environment.  Edit the name of the Intersight organization variable in ~/demo/pod1/variables.tf to match your new Intersight organization (like "demo-tf").  And by the way, "Visual Studio Code" is a great free editor for coding Terraform.
  # https://code.visualstudio.com/download


4. Add the following environment variables to your workstation and set their values.  If you do not have an API Key ID and Secret Key file, you will need to create them in Intersight under "System" > Settings > API Keys 
If you ran through the lab exercises, these values are already set.

    - TF_VAR_apikey     = the API Key ID you created in Intersight using version 2
   # Mac Example:   export TF_VAR_apikey=1234567890/23456abcd1355q29      <-- Use your API ID

    - TF_VAR_secretkey  = the contents of the secretkey file as a string
   # Mac Example:   export TF_VAR_secretkey=`cat ~/Downloads/SecretKey.txt`  <<-- backtick is not a quote
      OR (easier way to set secretkey variable ...)
   # Update path to "secretkey" in ~/demo/pod1/variables.tf file 


5.  Run from within "pod1" folder and review results in Intersight:
    terraform init
    terraform plan
    terraform apply

  You will find prestaged files in the pod1 folder with the ".add" suffix for adding additional domains and templates, simply remove the ".add" suffix and run terraform init/plan/apply sequences to use them to create additional objects.

6. After completion, manually delete domain profiles in intersight before running:  terraform destroy

### Note about Terraform destroy

When attempting a `terraform destroy`, Terraform is unable to remove the policies that are in use (IE: by the domain profile). To get around this, you will have to delete the domain profile manually first and possibly any server profiles that are using any of the profile templates or policies created.
You may need to run the destroy more than once to ensure you get everything removed.


---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
#  The "modules" folder is the workhorse for the Pod1 Configuration files. They contain most of the resource calls to create the Intersight objects.  The overriding configuration intentions are embedded in the modules.
---------------------------------------------------------------------------------------------------------------

# Module: imm-pod-pools-mod    - creates:
- IP Pool for Server IMC
- IP Pool for Chassis IMC
- MAC Pool
- WWNN Pool
- WWPN-A Pool
- WWPN-B Pool
- UUID Pool


# Module: imm-domain-fabric-6536 and imm-domain-fabric-6454-mod   - creates:
- Chassis Profile
- Chassis Policies
  - Chassis IP Access Policy
  - Chassis Power Policy
  - Thermal Policy
  - SNMP Policy (Also associated with Switch Profiles)
- Main Domain Cluster Profile
- FI Switch Profiles
- FI Switch Policies
  - Fabric Switch Control Policy
  - NTP Policy
  - Network Connectivity (DNS) Policy
  - Fabric System QoS Policy (CoS)
  - MultiCast Policy
  - Syslog Policy
- FI Switch Port Policies
  - FI-A Port Policy
  - FI-B Port Policy
  - Set FI Fabric Port Modes
  - Set Server Port Roles
  - Set Eth Port Channel Uplink Roles
  - Set FC Port Channel Uplink Roles
  - Set Eth Network Group Policy (VLANs) on Uplinks
  - Set Flow Control Policy
  - Set Link Aggregation Policy
  - Set Link Control Policy
- FI VLANs
  - Eth Network Policy (VLANs for Switches)
  - Fabric VLAN resources for Eth Network Policy
- FI VSANs
  - FI-A FC Network Policy
  - FI-B FC Network Policy
  - VSAN-A Fabric VSAN Resource Creatioon
  - VSAN-B Fabric VSAN Resource Creation

# Module: imm-pod-servers    - creates:
- Server Profile Template
- Access Policies
  - IMC Access Policy (IP Settings)
  - Serial Over LAN
  - IPMI Over LAN
  - Unused - Device Connector Policy
  - Unused - Local User
- BIOS
- Boot Order
- Eth vNic & Interface
- FC vHBA
  - vNic FC QoS Policy
  - vNic FC Adapter Policy (adapter tuning)
  - vNic FC Interface Policy (VSAN, WWPN, QoS, etc)
- FC VSAN Connectivity
- KVM & vMedia
- Monitor
  - SNMP
  - SysLog
- Network
  - Multicast Policy
  - LAN Connectivity Policy
  - Network Control Policy (CDP & LLDP)
  - Network Group Policy (VLANs)
- Power
- Server Resource Pool
- Server Storage