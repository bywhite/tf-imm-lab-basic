# Intersight IMM Demo Module  - bywhite

These modules are part of a demo set designed to enable IaC Enterprise operations for Intersight.
# https://github.com/bywhite/tf-imm-lab-basic

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



### Note about Terraform destroy

When attempting a `terraform destroy`, Terraform is unable to remove the policies that are used by the the UCS domain profile. To get around this, you will have to delete the domain profile manually and possibly any server profiles that are using any of the profiles or policies created. You will most likely have to run terraform destroy multiple times to fully remove the created objects due to dependencies and timing issues.
