# ==========================================================================================
# The purpose of this lab is to associate policies with profiles and re-organize the code 
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

output "ip_pool_chassis_moid" {
  description = "moid of the IP Pool for Chassis IMC Access Policy"
  value       = intersight_ippool_pool.ippool_pool_chassis.moid
}

output "ip_pool_chassis_name" {
  description = "moid of the IP Pool for Chassis IMC Access Policy"
  value       = intersight_ippool_pool.ippool_pool_chassis.name
}


# ===================== Start Code Resource Section  =====================================


# =============================================================================
# Chassis Profile
# -----------------------------------------------------------------------------

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


# =============================================================================
# IP Pool
# -----------------------------------------------------------------------------

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