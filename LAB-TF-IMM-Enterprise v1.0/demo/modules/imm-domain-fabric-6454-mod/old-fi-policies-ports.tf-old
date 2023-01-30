# This builds the FI port policy for 6432 FIs
#  Basic Example without SAN FC Configurations
# The port policy is the parent for port mode and role


# =============================================================================
# 6454 Switch Port Policies  
# -----------------------------------------------------------------------------

resource "intersight_fabric_port_policy" "fi6454_port_policy1" {
  name         = "${var.policy_prefix}-6454-port-policy-1"
  description  = var.description
  device_model = "UCS-FI-6454"
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
  # assign this policy to the domain profile being created
  profiles {
    moid        = intersight_fabric_switch_profile.fi6454_switch_profile_a.moid
    object_type = "fabric.SwitchProfile"
  }
  profiles {
    moid        = intersight_fabric_switch_profile.fi6454_switch_profile_b.moid
    object_type = "fabric.SwitchProfile"
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


# set the first four ports to be FC
resource "intersight_fabric_port_mode" "fi6454_port_mode1" {
  count = (var.fc_port_count_6454 > 0) ? 1 : 0

  custom_mode   = "FibreChannel"
  port_id_end   = var.fc_port_count_6454
  port_id_start = 1
  slot_id       = 1
  port_policy {
    moid = intersight_fabric_port_policy.fi6454_port_policy1.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# configure server ports
resource "intersight_fabric_server_role" "fi6454_server_role1" {
  for_each = var.server_ports_6454

  aggregate_port_id = 0
  port_id           = each.value
  slot_id           = 1
  port_policy {
    moid = intersight_fabric_port_policy.fi6454_port_policy1.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# configure uplink port channel
resource "intersight_fabric_uplink_pc_role" "fi6454_uplink_pc_role1" {
  pc_id = 100
  dynamic "ports" {
    for_each = var.port_channel_6454
    content {
      port_id           = ports.value
      aggregate_port_id = 0
      slot_id           = 1
    }
  }
  admin_speed = "Auto"
  port_policy {
    moid = intersight_fabric_port_policy.fi6454_port_policy1.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# -----------------------------------------------------------------------------
# END OF   6454 Switch Port Policies
# =============================================================================
