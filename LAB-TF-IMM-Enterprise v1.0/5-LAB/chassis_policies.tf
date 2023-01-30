# =============================================================================
#  Chassis Related  Policies
#    - Chassis Power Policy
#    - Thermal Policy
#    - SNMP Policy
#    - Chassis IMC Access Policy
# -----------------------------------------------------------------------------


# =============================================================================
# Chassis Power Policy
# -----------------------------------------------------------------------------
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

  profiles {
      moid        = intersight_chassis_profile.chassis_9508_profile.moid
      object_type = "chassis.Profile"
  }

}


# =============================================================================
# Thermal Policy
# -----------------------------------------------------------------------------
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/thermal_policy
#   Reference: https://github.com/jerewill-cisco/intersight-terraform-simplified/blob/main/policy_thermal.tf

resource "intersight_thermal_policy" "chassis_9508_thermal" {
  name = "thermal-balanced"

  organization {
    moid = local.org_moid
  }

  fan_control_mode = "Balanced"

  profiles {
      moid        = intersight_chassis_profile.chassis_9508_profile.moid
      object_type = "chassis.Profile"
  }

}


# =============================================================================
# SNMP Policy
# -----------------------------------------------------------------------------
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/thermal_policy
#   Reference: https://github.com/jerewill-cisco/intersight-terraform-simplified/blob/main/policy_thermal.tf

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

  profiles {
      moid        = intersight_chassis_profile.chassis_9508_profile.moid
      object_type = "chassis.Profile"
  }

}


# =============================================================================
# IMC Access Policy
# -----------------------------------------------------------------------------
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/access_policy
#   Reference: https://github.com/jerewill-cisco/intersight-terraform-simplified/blob/main/policy_imc_access.tf

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
  profiles {
      moid        = intersight_chassis_profile.chassis_9508_profile.moid
      object_type = "chassis.Profile"
  }
}
