# =============================================================================
#  Builds 6454 FI Port Related  Policies
#  - FI-A Port Policy
#  - FI-B Port Policy
#  - Set FI Fabric Port Modes
#  - Set Server Port Roles
#  - Set Eth Port Channel Uplink Roles
#  - Set FC Port Channel Uplink Roles
#  - Set Eth Network Group Policy (VLANs) on Uplinks
#  - Set Flow Control Policy
#  - Set Link Aggregation Policy
#  - Set Link Control Policy
# -----------------------------------------------------------------------------

# =============================================================================
# 6454 Switch Port Policies
# -----------------------------------------------------------------------------

### 6454 FI-A port_policy ####
# Associated with 6 other policies
resource "intersight_fabric_port_policy" "fi6454_port_policy_a" {
  name         = "${var.policy_prefix}-fi-a-ports"
  description  = var.description
  device_model = "UCS-FI-6454"
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
  # assign this policy to the FI-A switch profile being created
  profiles {
    moid        = intersight_fabric_switch_profile.fi6454_switch_profile_a.moid
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

### 6454 FI-B port_policy ####
# Associated with 6 other policies
resource "intersight_fabric_port_policy" "fi6454_port_policy_b" {
  name         = "${var.policy_prefix}-fi-b-ports"
  description  = var.description
  device_model = "UCS-FI-6454"
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
  # assign this policy to the FI-B switch profile being created
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

# set the first X ports to be FC on FI-A and FI-B
resource "intersight_fabric_port_mode" "fi6454_port_mode_a" {
  count = (var.fc_port_count_6454 > 0) ? 1 : 0

  custom_mode   = "FibreChannel"
  port_id_end   = var.fc_port_count_6454
  port_id_start = 1
  slot_id       = 1
  port_policy {
    moid = intersight_fabric_port_policy.fi6454_port_policy_a.moid
  }

  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# set the first X ports to be FC on FI-A and FI-B
resource "intersight_fabric_port_mode" "fi6454_port_mode_b" {
  count = (var.fc_port_count_6454 > 0) ? 1 : 0

  custom_mode   = "FibreChannel"
  port_id_end   = var.fc_port_count_6454
  port_id_start = 1
  slot_id       = 1

  port_policy {
    moid = intersight_fabric_port_policy.fi6454_port_policy_b.moid
  }

  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


# assign server role to designated ports on FI-A  port_policy
resource "intersight_fabric_server_role" "fi6454_server_role_a" {
  for_each = var.server_ports_6454

  aggregate_port_id = 0
  port_id           = each.value
  slot_id           = 1
  port_policy {
    moid = intersight_fabric_port_policy.fi6454_port_policy_a.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# assign server role to designated ports on FI-B port_policy
resource "intersight_fabric_server_role" "fi6454_server_role_b" {
  for_each = var.server_ports_6454

  aggregate_port_id = 0
  port_id           = each.value
  slot_id           = 1
  port_policy {
    moid = intersight_fabric_port_policy.fi6454_port_policy_b.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# assign ports for Eth uplink port channel on 6454 FI-A  port_policy
resource "intersight_fabric_uplink_pc_role" "fi6454_uplink_pc_role_a" {
  pc_id = 49
  dynamic "ports" {
    for_each = var.port_channel_6454
    content {
      port_id           = ports.value
      aggregate_port_id = 0
      slot_id           = 1
      class_id          = "fabric.PortIdentifier"
      object_type       = "fabric.PortIdentifier"
    }
  }
  admin_speed = "Auto"
  port_policy {
    moid        = intersight_fabric_port_policy.fi6454_port_policy_a.moid
    object_type = "fabric.PortPolicy"
  }
  eth_network_group_policy {
    moid = intersight_fabric_eth_network_group_policy.fabric_eth_network_group_policy_a.moid 
  }
  flow_control_policy {
    moid =  intersight_fabric_flow_control_policy.fabric_flow_control_policy.moid
  }
  link_aggregation_policy {
    moid = intersight_fabric_link_aggregation_policy.fabric_link_agg_policy.moid 
  }
  link_control_policy {
    moid =  intersight_fabric_link_control_policy.fabric_link_control_policy.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# assign ports for Eth uplink port channel on 6454 FI-B port_policy
resource "intersight_fabric_uplink_pc_role" "fi6454_uplink_pc_role_b" {
  pc_id = 34
  #Port Channel ID is not seen by connected network switch
  dynamic "ports" {
    for_each = var.port_channel_6454
    content {
      port_id           = ports.value
      aggregate_port_id = 0
      slot_id           = 1
      class_id          = "fabric.PortIdentifier"
      object_type       = "fabric.PortIdentifier"
    }
  }
  admin_speed = "Auto"
  port_policy {
    moid        = intersight_fabric_port_policy.fi6454_port_policy_b.moid
    object_type = "fabric.PortPolicy"
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  eth_network_group_policy {
    moid = intersight_fabric_eth_network_group_policy.fabric_eth_network_group_policy_b.moid
  }
  flow_control_policy {
    moid =  intersight_fabric_flow_control_policy.fabric_flow_control_policy.moid
  }
 link_aggregation_policy {
    moid = intersight_fabric_link_aggregation_policy.fabric_link_agg_policy.moid 
  }
  link_control_policy {
    moid =  intersight_fabric_link_control_policy.fabric_link_control_policy.moid
  }
}

# Configure FC uplink Port Channel for FI-A
resource "intersight_fabric_fc_uplink_pc_role" "fabric_fc_uplink_pc_role_a" {
  count = (var.fc_port_count_6454 > 0) ? 1 : 0
# 6454 does not use FC breakouts, all ag_port are 0 instead of ports.value.aggport
# admin_speed   = "16Gbps"
  admin_speed   = "32Gbps"
  fill_pattern  = "Idle"
  #fill_pattern = "Arbff"
  vsan_id      = var.fc_uplink_pc_vsan_id_a
  #vsan_id = var.fc_uplink_pc_vsan_id_a
  pc_id = 8
  port_policy {
    moid = intersight_fabric_port_policy.fi6454_port_policy_a.moid
  }
  dynamic "ports" {
    for_each = var.fc_port_channel_6454
    content {
      aggregate_port_id = 0
      port_id           = ports.value.port
      slot_id           = 1
    }
  }
  depends_on = [
    intersight_fabric_port_mode.fi6454_port_mode_a, intersight_fabric_port_policy.fi6454_port_policy_a
  ]
}

# Configure FC uplink Port Channel for FI-B
resource "intersight_fabric_fc_uplink_pc_role" "fabric_fc_uplink_pc_role_b" {
  count = (var.fc_port_count_6454 > 0) ? 1 : 0
# 6454 does not use FC breakouts, all ag_port are 0 instead of ports.value.aggport
# admin_speed   = "16Gbps"
  admin_speed   = "32Gbps"
  fill_pattern  = "Idle"
  #fill_pattern = "Arbff"
  vsan_id      = var.fc_uplink_pc_vsan_id_b
  #vsan_id = var.fc_uplink_pc_vsan_id_b
  pc_id = 8
  port_policy {
    moid = intersight_fabric_port_policy.fi6454_port_policy_b.moid
  }
  dynamic "ports" {
    for_each = var.fc_port_channel_6454
    content {
      aggregate_port_id = 0
      port_id           = ports.value.port
      slot_id           = 1
    }
  }
  depends_on = [
    intersight_fabric_port_mode.fi6454_port_mode_b, intersight_fabric_port_policy.fi6454_port_policy_b
  ]
}

resource "intersight_fabric_eth_network_group_policy" "fabric_eth_network_group_policy_a" {
  name        = "${var.policy_prefix}-fi-a-eth_network_group-1"
  description = "VLAN Group listing allowed on Uplinks"
  vlan_settings {
    native_vlan   = 1
    allowed_vlans = var.switch_vlans_6454
    object_type   = "fabric.VlanSettings"
  }
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_fabric_eth_network_group_policy" "fabric_eth_network_group_policy_b" {
  name        = "${var.policy_prefix}-fi-b-eth_network_group-1"
  description = "VLAN Group listing allowed on Uplinks"
  vlan_settings {
    native_vlan   = 1
    allowed_vlans = var.switch_vlans_6454
    object_type   = "fabric.VlanSettings"
  }
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_fabric_flow_control_policy" "fabric_flow_control_policy" {
  name        = "${var.policy_prefix}-fo-flow-control-1"
  description = "Port Flow control for Eth Port Channel Uplink Ports"
  priority_flow_control_mode = "auto"
  receive_direction = "Disabled"
  send_direction = "Disabled"
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_fabric_link_aggregation_policy" "fabric_link_agg_policy" {
  name        = "${var.policy_prefix}-fi-link-agg-1"
  description = "Link Aggregation Settings for Eth Port Channel Uplink Ports"
  lacp_rate = "normal"
  suspend_individual = false
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_fabric_link_control_policy" "fabric_link_control_policy" {
  name        = "${var.policy_prefix}-fi-link-control-1"
  description = "Link Control Settings for Eth Port Channel Uplink Ports"
  udld_settings {
    admin_state = "Enabled"
    mode        = "normal"
  }
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
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
