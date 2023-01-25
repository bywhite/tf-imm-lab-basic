# =============================================================================
# The purpose of this section is to create chassis profile supporting policies
# Chassis Policies
#  - Power Policy
#  - Thermal Policy
#  - SNMP Policy
#  - Access Policy
# -----------------------------------------------------------------------------


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

  # profiles {
  #     moid        = intersight_chassis_profile.chassis_9508_profile.moid
  #     object_type = "chassis.Profile"
  # }
  dynamic "profiles" {
    for_each = local.chassis_profile_moids
    content {
      moid        = profiles.value
      object_type = "chassis.Profile"
    }
  }


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

  # profiles {
  #     moid        = intersight_chassis_profile.chassis_9508_profile.moid
  #     object_type = "chassis.Profile"
  # }
  dynamic "profiles" {
    for_each = local.chassis_profile_moids
    content {
      moid        = profiles.value
      object_type = "chassis.Profile"
    }
  }
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

  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }

  # profiles {
  #     moid        = intersight_chassis_profile.chassis_9508_profile.moid
  #     object_type = "chassis.Profile"
  # }
  dynamic "profiles" {
    for_each = local.chassis_profile_moids
    content {
      moid        = profiles.value
      object_type = "chassis.Profile"
    }
  }
}


# =============================================================================
# IMC Access Policy
# -----------------------------------------------------------------------------
# Create an IMC Access Policy               (Note: The GUI name is not exactly the same as the TF resource name)
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/access_policy
#   Reference: https://github.com/jerewill-cisco/intersight-terraform-simplified/blob/main/policy_imc_access.tf
# Use the pool module output for inband_ip_pool moid
# ** Replace:   intersight_ippool_pool.ippool_pool_chassis.moid
# ** with:      module.ip_pool1.ip_pool_chassis_moid

resource "intersight_access_policy" "chassis_imc_access" {
  name        = "chassis-imc-access"
  description = "Chassis imc access policy"
  inband_vlan = 19
  inband_ip_pool {
    object_type = "ippool.Pool"
    moid        = module.ip_pool1.ip_pool_chassis_moid
  }
  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }

  dynamic "profiles" {
    for_each = intersight_chassis_profile.chassis_9508_profile
    content {
      moid        = profiles.value.id
      object_type = "chassis.Profile"
    }
  }
  # Uncomment this block when you use the module output variable
  # depends_on = [
  #   module.ip_pool1
  # ]
}
