# ==========================================================================================
# The purpose of this module is to create a chassis profile with required policies and pool
# This file initializes required external resources
# 
# ------------------------------------------------------------------------------------------
# IMM Code Examples Can Be Found at:
# https://github.com/jerewill-cisco?tab=repositories
# https://github.com/bywhite/tf-imm-pod-example-code
# https://github.com/terraform-cisco-modules/terraform-intersight-imm/tree/master/modules
# https://github.com/scotttyso/terraform-intersight-easy-imm
# ------------------------------------------------------------------------------------------


# Define Terraform Providers required for our main module

terraform {

    #Setting required version "=" to eliminate any future adverse behavior without testing first
    required_providers {
        intersight = {
            source = "CiscoDevNet/intersight"
            version = "=1.0.34"
        }
    }
}

provider "intersight" {
    apikey = var.apikey
    secretkey = var.secretkey
    endpoint = "https://intersight.com"
}

#The target Intersight Organization should be created manually in Intersight
# Example Use:  org_moid = data.intersight_organization_organization.my_org.id

data "intersight_organization_organization" "my_org" {
    name = "juan"
}


# ===================== END MAIN Code Block ==========================================



# ===================== Define Local Variables  ==========================================
locals {

  org_moid = data.intersight_organization_organization.my_org.id  

}


# ===================== Define Input Variables  ==========================================
# Define Input Variables
# Usage from CLI:  terraform plan -var "api_key=<my-key>" -var "secretkey=<pem-key>"
# Variables can be set in TFCB "Variables" section of the Workspace
# Variables can be set with environment variables (MAC):  export TF_VAR_api_key=<my-api-key>

#         export TF_VAR_api_key=<my-api-key>
variable "apikey" {
  description = "API key ID for Intersight account"
  type        = string
}

#         export TF_VAR_api_key=<my-secret-pem-key>
#   or    export TF_VAR_secretkey=`cat ~/Downloads/SecretKey.txt` 
variable "secretkey" {
  description = "secret key for Intersight API vsn 2"
  type        = string
}


# ===================== Define Output Variables  =========================================
# Define Output Variables
output "my_org" {
  value       = data.intersight_organization_organization.my_org.name
  description = "My Intersight Organization Name"
  sensitive   = false
}


# ===================== Start Code Resource Section  =====================================


# IMM Chassis Profile resource
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/chassis_profile
# ** Set policy alias (resource's instance name) to "chassis_9508_profile"
# ** Set "action" and "control_action" parameters to "No-op"
# ** Set "error_state" parameter to ""
# ** Set the orgainization "moid" equal to your local organization variable (local.org_moid)

resource "intersight_chassis_profile" "chassis_9508_profile" {
  name            = "chassis_profile1"
  description     = "chassis profile"
  type            = "instance"
  target_platform = "FIAttached"
  action          = "No-op"
  config_context {
    object_type    = "policy.ConfigContext"
    control_action = "No-op"
    error_state    = ""
  }
  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }
}

# =============================================================================
# Chassis Power Policy
# -----------------------------------------------------------------------------
# Create a Power Policy
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/power_policy
#   Reference: https://github.com/jerewill-cisco/intersight-terraform-simplified/blob/main/policy_power.tf
# ** Set policy alias (resource's instance name) to "chassis_9508_power"
# ** Set "power_profiling" parameter to "Enabled"
# ** Set "power_restore_state" parameter to "LastState"
# ** Set "redundancy_mode" parameter to "Grid"
# ** Set the orgainization "moid" equal to your local organization variable (local.org_moid)
resource "intersight_power_policy" "chassis_9508_power" {
  name = "grid_last_state"

  organization {
    moid = local.org_moid
  }

  power_profiling     = "Enabled"
  power_restore_state = "LastState"
  redundancy_mode     = "Grid"
}


# =============================================================================
# Thermal Policy
# -----------------------------------------------------------------------------
# Create a Thermal Policy
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/thermal_policy
#   Reference: https://github.com/jerewill-cisco/intersight-terraform-simplified/blob/main/policy_thermal.tf
# ** Just create a single policy
# ** Set policy alias (resource's instance name) to "chassis_9508_thermal"
# ** Set "name" parameter to "thermal-balanced"
# ** Set "fan_control_mode" parameter to "Balanced"
# ** Set the orgainization "moid" equal to your local organization variable (local.org_moid)

# resource "intersight_thermal_policy" "thermal" {
#   for_each = toset(["Balanced", "LowPower", "HighPower", "MaximumPower", "Acoustic"])
#   name = lower(each.key)
#   organization {
#     moid = local.org_moid
#   }
#   fan_control_mode = each.key
# }

resource "intersight_thermal_policy" "chassis_9508_thermal" {
  name = "thermal-balanced"

  organization {
    moid = local.org_moid
  }

  fan_control_mode = "Balanced"
}


# =============================================================================
# SNMP Policy
# -----------------------------------------------------------------------------
# Create a SNMP Policy
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/thermal_policy
#   Reference: https://github.com/jerewill-cisco/intersight-terraform-simplified/blob/main/policy_thermal.tf
# ** Set policy alias (resource's var name) to "snmp1"
# ** Set the orgainization "moid" equal to your local organization variable (local.org_moid)
# ** Set "auth_password" parameter to "Cisco123"
# ** Set "privacy_password" parameter to "Cisco123"
# ** For now, make sure "profiles" block of code is "#" commented out (if it exists in your code)
# ensure you do not  have any "var" variables defined yet

resource "intersight_snmp_policy" "snmp1" {
  name                    = "snmp1"
  description             = "testing smtp policy"
  enabled                 = true
  snmp_port               = 1983
  access_community_string = "dummy123"
  community_access        = "Disabled"
  trap_community          = "TrapCommunity"
  sys_contact             = "aanimish"
  sys_location            = "Karnataka"
  engine_id               = "vvb"
  snmp_users {
    name         = "demouser"
    privacy_type = "AES"
    auth_password    = "Cisco123"
    privacy_password = "Cisco123"
    security_level = "AuthPriv"
    auth_type      = "SHA"
    object_type    = "snmp.User"
  }
  snmp_traps {
    destination = "10.10.10.1"
    enabled     = false
    port        = 660
    type        = "Trap"
    user        = "demouser"
    nr_version  = "V3"
    object_type = "snmp.Trap"
  }
  # profiles {
  #   moid        = var.profile
  #   object_type = "server.Profile"
  # }
  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }
}


# =============================================================================
# IMC Access Policy
# -----------------------------------------------------------------------------
# Create an IMC Access Policy               (Note: The GUI name is not exactly the same as the TF resource name)
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/access_policy
#   Reference: https://github.com/jerewill-cisco/intersight-terraform-simplified/blob/main/policy_imc_access.tf
# ** Just create an inband only policy
# ** Set policy alias (resource's var name) to "chassis_imc_access"
# ** Set "name" parameter to "chassis-imc-access"
# ** After you create an IP Pool Resource, set the inband_ip_pool "moid" value to the pool id
# ** Set the orgainization "moid" equal to your local organization variable (local.org_moid)

resource "intersight_access_policy" "chassis_imc_access" {
  name        = "chassis-imc-access"
  description = "Chassis imc access policy"
  inband_vlan = 19
  inband_ip_pool {
    object_type = "ippool.Pool"
    moid        = intersight_ippool_pool.ippool_pool_chassis.moid
  }
  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }
}

# Create an IP Pool
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/ippool_pool
#   Reference: https://github.com/jerewill-cisco/intersight-terraform-simplified/blob/main/pools_ip.tf
# ** Set policy alias (resource's var name) to "ippool_pool_chassis"
# ** Configure with ip_v4_config 
# ** Set "name" parameter to "pool-ip-chassis-imc"
# ** Set "gateway" parameter to "10.10.10.1"
# ** Set "netmask" parameter to "255.255.255.0"
# ** Add an IP v4 block
        # ip_v4_blocks {
        #   from = "10.10.10.10"
        #   size = "240"
        # }
# ** Set the orgainization "moid" equal to your local organization variable (local.org_moid)
# After you create the IP Pool Resource, set the above chassis_imc_access resource inband_ip_pool moid

resource "intersight_ippool_pool" "ippool_pool_chassis" {
  name             = "pool-ip-chassis-imc"
  description      = "ippool pool for Chassis IMC access"
  assignment_order = "sequential"
  ip_v4_config {
    object_type = "ippool.IpV4Config"
    gateway     = "10.10.10.1"
    netmask     = "255.255.255.0"
    primary_dns = "8.8.8.8"
  }

    ip_v4_blocks {
      from = "10.10.10.10"
      size = "240"
  }

  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }
}


# Create "output" variables for the ip pool "moid" and "name"
#   Reference: https://developer.hashicorp.com/terraform/language/values/outputs
#   Refer to earlier output code block as a reference
# ** Use "ip_pool_chassis_moid" for the IP Pool moid variable
# **    set its "value" to the created pool resource's "moid" attribute
# **      intersight_ippool_pool.ippool_pool_chassis.moid
# ** Use "ip_pool_chassis_name" for the IP Pool name output variable
# **    set its "value" to the created pool resource's "name" attribute

output "ip_pool_chassis_moid" {
  description = "moid of the IP Pool for Chassis IMC Access Policy"
  value       = intersight_ippool_pool.ippool_pool_chassis.moid
}
output "ip_pool_chassis_name" {
  description = "moid of the IP Pool for Chassis IMC Access Policy"
  value       = intersight_ippool_pool.ippool_pool_chassis.name
}



# ****************************************************************************
# ========!=================!====================!==================!=========
# ================!=================!====================!====================
# ========!=================!====================!==================!=========
# * * * * * * * * *       BEGIN  LAB 4-A  SECTION            * * * * * * * * *


## For each of the policies you have created (Power, Thermal, SNMP, IMC Access)
#  add to each policy a section that associates the policy with the chassis profile
/*

  profiles {
      moid        = intersight_chassis_profile.chassis_9508_profile.moid
      object_type = "chassis.Profile"
  }

*/



# ========!=================!====================!==================!=========
# ================!=================!====================!=====================
# ========!=================!====================!==================!=========
# * * *  Before Proceeding further, test your code * * * 

#<<<<<  Run Terraform init and Terraform plan when ready     >>>>>>
#<<<<<  If successful, run Terraform apply and enter yes     >>>>>>
#<<<<<  If successful, run Terraform apply a second time     >>>>>>
#<<<<<  Check your new creation using the Intersight GUI     >>>>>>
# Verify that your chassis Profile is now associated with policies





# ****************************************************************************
# ========!=================!====================!==================!=========
# ================!=================!====================!====================
# ========!=================!====================!==================!=========
# * * * * * * * * *       BEGIN  LAB 4-B  SECTION            * * * * * * * * *


# Move (cut & paste) above code sections into their respective files
# The only thing left in this file should be:
#     The initial Terraform block, provider block, data block

# * * *  Before Proceeding further, test your code * * * 
# There should be "No Changes" after relocating code blocks

#<<<<<  Run Terraform init and Terraform plan when ready     >>>>>>
#<<<<<  If successful, run Terraform apply and enter yes     >>>>>>
#<<<<<  If successful, run Terraform apply a second time     >>>>>>
#<<<<<  Check your new creation using the Intersight GUI     >>>>>>


#<<<<<  Run       Terraform destroy      * when instructed   >>>>>>