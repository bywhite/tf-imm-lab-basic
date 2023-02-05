# ==========================================================================================
# The purpose of this lab is to create an IP Pool for a new IMC Access Policy
# 
# ------------------------------------------------------------------------------------------


terraform {

    required_providers {
        intersight = {
            source = "CiscoDevNet/intersight"
            version = "=1.0.34"
        }
    }
}

provider "intersight" {
  apikey    = var.apikey
  secretkey = local.secretkey
  endpoint  = "https://intersight.com"
}

data "intersight_organization_organization" "my_org" {
    name = "demo-tf"
}


# ===================== Define Local Variables  ==========================================

locals {

  org_moid = data.intersight_organization_organization.my_org.id
  secretkey = file("../SecretKey.txt")

}


# ===================== Define Input Variables  ==========================================

variable "apikey" {
  description = "API key ID for Intersight account"
  type        = string
}


# ===================== Define Output Variables  =========================================

output "my_org" {
  value       = data.intersight_organization_organization.my_org.name
  description = "My Intersight Organization Name"
  sensitive   = false
}


# ===================== Start Code Resource Section  =====================================


# =============================================================================
# Chassis Profile
# -----------------------------------------------------------------------------
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/chassis_profile

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

# We only want 1 policy not a bunch of thermal policies, so we don't use the for_each
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

# Note we are not assigning this policy to any profiles, yet
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

# ****************************************************************************
# ========!=================!====================!==================!=========
# ================!=================!====================!====================
# ========!=================!====================!==================!=========
# * * * * * * * * *       BEGIN  LAB 3  SECTION              * * * * * * * * *



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




# =============================================================================
# IP Pool
# -----------------------------------------------------------------------------
# Create an IP Pool for the Chassis IMC Access Policy
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



# =============================================================================
# Create more variables  - Add them into the appropriate section at top of page
# -----------------------------------------------------------------------------
# Create "output" variables described below for the ip pool "moid" and "name"
#   Reference: https://developer.hashicorp.com/terraform/language/values/outputs
# ** Use "ip_pool_chassis_moid" for the IP Pool moid variable
# **    set its "value" to the created pool resource's "moid" attribute
# **            =intersight_ippool_pool.ippool_pool_chassis.moid
# ** Use "ip_pool_chassis_name" for the IP Pool name output variable
# **    set its "value" to the created pool resource's ".name" attribute




# ========!=================!====================!==================!=========
# ================!=================!====================!=====================
# ========!=================!====================!==================!=========
# * * *  Before Proceeding further, test your code * * * 

#<<<<<  Run Terraform init and Terraform plan when ready     >>>>>>
#<<<<<  If successful, run Terraform apply and enter yes     >>>>>>
#<<<<<  If successful, run Terraform apply a second time     >>>>>>
#<<<<<  Check your new creation using the Intersight GUI     >>>>>>

# NOTE the 3 output variables returned after you run terraform apply


#<<<<<  Run       Terraform destroy      * when instructed   >>>>>>
# Run: terraform destroy
#          when prompted enter: yes