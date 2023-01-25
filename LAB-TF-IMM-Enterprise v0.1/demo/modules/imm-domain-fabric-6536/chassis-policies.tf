# =============================================================================
#  Chassis Related  Policies
#  - Chassis IP Access Policy
#  - Chassis Power Policy
#  - Thermal Policy
#  - SNMP Policy (Also associated with Switch Profiles)
#  - 
#  Uses: local.chassis_profile_mods to associate with Chassis Profile
# -----------------------------------------------------------------------------


# =============================================================================
# Chassis IP Access Policy
# -----------------------------------------------------------------------------
resource "intersight_access_policy" "chassis_9508_access" {
  name        = "${var.policy_prefix}-chassis-access-1"
  description = var.description
  inband_vlan = var.chassis_imc_access_vlan
  inband_ip_pool {
    object_type  = "ippool.Pool"
    moid         = var.chassis_imc_ip_pool_moid
  }
  organization {
    moid        = var.organization
    object_type = "organization.Organization"
  }
  dynamic "profiles" {
    for_each = local.chassis_profile_moids
    content {
      moid        = profiles.value
      object_type = "chassis.Profile"
    }
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  depends_on = [
    intersight_chassis_profile.chassis_9508_profile
  ]
}

# =============================================================================
# Chassis Power Policy
# -----------------------------------------------------------------------------
resource "intersight_power_policy" "chassis_9508_power" {
  name        = "${var.policy_prefix}-chassis-power-1"
  description              = var.description
  power_save_mode = "Enabled"
  dynamic_rebalancing = "Enabled"
  extended_power_capacity = "Enabled"
  allocated_budget = 0
  redundancy_mode = "Grid"
  organization {
    moid        = var.organization
    object_type = "organization.Organization"
  }
  dynamic "profiles" {
    for_each = local.chassis_profile_moids
    content {
      moid        = profiles.value
      object_type = "chassis.Profile"
    }
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  depends_on = [
    intersight_chassis_profile.chassis_9508_profile
  ]
}

# =============================================================================
# Thermal Policy
# -----------------------------------------------------------------------------
resource "intersight_thermal_policy" "chassis_9508_thermal" {
  name        = "${var.policy_prefix}-chassis-thermal-1"
  description              = var.description
  fan_control_mode = "Balanced"
  organization {
    moid        = var.organization
    object_type = "organization.Organization"
  }
  dynamic "profiles" {
    for_each = local.chassis_profile_moids
    content {
      moid        = profiles.value
      object_type = "chassis.Profile"
    }
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  depends_on = [
    intersight_chassis_profile.chassis_9508_profile
  ]
}


# =============================================================================
# SNMP Policy
# -----------------------------------------------------------------------------

resource "intersight_snmp_policy" "snmp1" {
  name        = "${var.policy_prefix}-chassis-snmp-policy"
  description              = var.description
  enabled                 = true
  snmp_port               = 161
  access_community_string = "anythingbutpublic"
  community_access        = "Disabled"
  trap_community          = "TrapCommunity"
  sys_contact             = "The SysAdmin"
  sys_location            = "The Data Center"
  engine_id               = "vvb"
  snmp_users {
    name         = "snmpuser"
    privacy_type = "AES"
    auth_password    = var.snmp_password
    privacy_password = var.snmp_password
    security_level = "AuthPriv"
    auth_type      = "SHA"
    object_type    = "snmp.User"
  }
  snmp_traps {
    destination = var.snmp_ip
    enabled     = false
    port        = 660
    type        = "Trap"
    user        = "snmpuser"
    nr_version  = "V3"
    object_type = "snmp.Trap"
  }
  dynamic "profiles" {
    for_each = local.chassis_profile_moids
    content {
      moid        = profiles.value
      object_type = "chassis.Profile"
    }
  }
  profiles {
    moid        = intersight_fabric_switch_profile.fi6536_switch_profile_a.moid
    object_type = "fabric.SwitchProfile"
  }
  profiles {
    moid        = intersight_fabric_switch_profile.fi6536_switch_profile_b.moid
    object_type = "fabric.SwitchProfile"
  }
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
    depends_on = [
    intersight_chassis_profile.chassis_9508_profile
  ]
}
