# =============================================================================
#  Builds 6536 FI Port Related  Policies
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
# 6536 Switch Port Policies
# -----------------------------------------------------------------------------

### 6536 FI-A port_policy ####
# Associated with 6 other policies
resource "intersight_fabric_port_policy" "fi6536_port_policy_a" {
  name         = "${var.policy_prefix}-fi-a-ports"
  description  = var.description
  device_model = "UCS-FI-6536"
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
  # assign this policy to the FI-A switch profile being created
  profiles {
    moid        = intersight_fabric_switch_profile.fi6536_switch_profile_a.moid
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

### 6536 FI-B port_policy ####
# Associated with 6 other policies
resource "intersight_fabric_port_policy" "fi6536_port_policy_b" {
  name         = "${var.policy_prefix}-fi-b-ports"
  description  = var.description
  device_model = "UCS-FI-6536"
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
  # assign this policy to the FI-B switch profile being created
  profiles {
    moid        = intersight_fabric_switch_profile.fi6536_switch_profile_b.moid
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


# set the last two ports to be FC on 6536 FI-A
resource "intersight_fabric_port_mode" "fi6536_port_mode_a-35" {
  #custom_mode   = "BreakoutFibreChannel16G"
  custom_mode    = "BreakoutFibreChannel32G"
  port_id_end    = 35
  port_id_start = 35
  slot_id        = 1
  port_policy {
    moid = intersight_fabric_port_policy.fi6536_port_policy_a.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  depends_on = [
    intersight_fabric_port_mode.fi6536_port_mode_a-36
  ]
}

resource "intersight_fabric_port_mode" "fi6536_port_mode_a-36" {
  #custom_mode   = "BreakoutFibreChannel16G"
  custom_mode    = "BreakoutFibreChannel32G"
  port_id_end    = 36
  port_id_start = 36
  slot_id        = 1
  port_policy {
    moid = intersight_fabric_port_policy.fi6536_port_policy_a.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# set the last two ports to be FC on 6536 FI-B
resource "intersight_fabric_port_mode" "fi6536_port_mode_b-35" {
 #custom_mode   = "BreakoutFibreChannel16G"
  custom_mode   = "BreakoutFibreChannel32G"
  port_id_end   = 35
  port_id_start = 35
  slot_id       = 1
  port_policy {
    moid = intersight_fabric_port_policy.fi6536_port_policy_b.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  depends_on = [
    intersight_fabric_port_mode.fi6536_port_mode_b-36
  ]
}

resource "intersight_fabric_port_mode" "fi6536_port_mode_b-36" {
  #custom_mode   = "BreakoutFibreChannel16G"
  custom_mode   = "BreakoutFibreChannel32G"
  port_id_end   = 36
  port_id_start = 36
  slot_id       = 1
  port_policy {
    moid = intersight_fabric_port_policy.fi6536_port_policy_b.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
 
 # FI 6536 can use any port range as 4x ethernet breakout ports
resource "intersight_fabric_port_mode" "fi6536_port_mode_a-1" {
  #count = (var.eth_breakout_count > 0) ? 1 : 0
  count = var.eth_breakout_count
  custom_mode   = "BreakoutEthernet25G"
  #custom_mode   = "BreakoutEthernet10G"
  port_id_end   = var.eth_breakout_start + count.index
  port_id_start = var.eth_breakout_start + count.index
  slot_id       = 1
  port_policy {
    moid = intersight_fabric_port_policy.fi6536_port_policy_a.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  depends_on = [
    intersight_fabric_server_role.fi6536_server_role_a, intersight_fabric_server_role.fi6536_server_role_b
  ]
}

# FI 6536 can use any port range as 4x ethernet breakout ports
 resource "intersight_fabric_port_mode" "fi6536_port_mode_b-1" {
  count = var.eth_breakout_count
  custom_mode   = "BreakoutEthernet25G"
  #custom_mode   = "BreakoutEthernet10G"
  port_id_end   = var.eth_breakout_start + count.index
  port_id_start = var.eth_breakout_start + count.index
  slot_id       = 1
  port_policy {
    moid = intersight_fabric_port_policy.fi6536_port_policy_b.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
 depends_on = [
   intersight_fabric_server_role.fi6536_server_role_a, intersight_fabric_server_role.fi6536_server_role_b
 ]
}

# assign server role to designated ports on FI-A Aggregate ports
resource "intersight_fabric_server_role" "server_role_aggr_a" {
  for_each = var.eth_breakout_count != 0 ? var.eth_aggr_server_ports : {}

  aggregate_port_id = each.value.aggregate_port_id
  port_id           = each.value.port_id
  slot_id           = 1

  port_policy {
    moid = intersight_fabric_port_policy.fi6536_port_policy_a.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  depends_on = [
    intersight_fabric_port_mode.fi6536_port_mode_a-1
  ]
}

# assign server role to designated ports on FI-B Aggregate ports
resource "intersight_fabric_server_role" "server_role_aggr_b" {
  for_each = var.eth_breakout_count != 0 ? var.eth_aggr_server_ports : {}

  aggregate_port_id = each.value.aggregate_port_id
  port_id           = each.value.port_id
  slot_id           = 1

  port_policy {
    moid = intersight_fabric_port_policy.fi6536_port_policy_b.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  depends_on = [
    intersight_fabric_port_mode.fi6536_port_mode_b-1
  ]
}


 
# assign server role to designated ports on FI-A  port_policy
resource "intersight_fabric_server_role" "fi6536_server_role_a" {
  for_each = var.server_ports_6536

  aggregate_port_id = 0
  port_id           = each.value
  slot_id           = 1
  port_policy {
    moid = intersight_fabric_port_policy.fi6536_port_policy_a.moid
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
resource "intersight_fabric_server_role" "fi6536_server_role_b" {
  for_each = var.server_ports_6536

  aggregate_port_id = 0
  port_id           = each.value
  slot_id           = 1
  port_policy {
    moid = intersight_fabric_port_policy.fi6536_port_policy_b.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# assign ports for Eth uplink port channel on both 6536 FI  port_policy
resource "intersight_fabric_uplink_pc_role" "fi6536_uplink_pc_role_a" {
  pc_id = 33
  dynamic "ports" {
    for_each = var.port_channel_6536
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
    moid        = intersight_fabric_port_policy.fi6536_port_policy_a.moid
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

# assign ports for Eth uplink port channel on both 6536 FI port_policy
resource "intersight_fabric_uplink_pc_role" "fi6536_uplink_pc_role_b" {
  pc_id = 34
  #Port Channel ID is not seen by connected network switch
  dynamic "ports" {
    for_each = var.port_channel_6536
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
    moid        = intersight_fabric_port_policy.fi6536_port_policy_b.moid
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
# admin_speed   = "16Gbps"
  admin_speed   = "32Gbps"
  fill_pattern  = "Idle"
  #fill_pattern = "Arbff"
  vsan_id       = var.fc_uplink_pc_vsan_id_a
  pc_id         = 35
  port_policy {
    moid = intersight_fabric_port_policy.fi6536_port_policy_a.moid
  }
  dynamic "ports" {
    for_each = var.fc_port_channel_6536
    content {
      aggregate_port_id = ports.value.aggport
      port_id           = ports.value.port
      slot_id           = 1
    }
  }
  depends_on = [
    intersight_fabric_port_mode.fi6536_port_mode_a-35, intersight_fabric_port_mode.fi6536_port_mode_a-36
  ]
}

# Configure FC uplink Port Channel for FI-A
resource "intersight_fabric_fc_uplink_pc_role" "fabric_fc_uplink_pc_role_b" {
# admin_speed   = "16Gbps"
  admin_speed   = "32Gbps"
  fill_pattern  = "Idle"
  #fill_pattern = "Arbff"
  vsan_id       = var.fc_uplink_pc_vsan_id_b
  pc_id         = 36
  port_policy {
    moid = intersight_fabric_port_policy.fi6536_port_policy_b.moid
  }
  dynamic "ports" {
    for_each = var.fc_port_channel_6536
    content {
      aggregate_port_id = ports.value.aggport
      port_id           = ports.value.port
      slot_id           = 1
    }
  }
  depends_on = [
    intersight_fabric_port_mode.fi6536_port_mode_b-35, intersight_fabric_port_mode.fi6536_port_mode_b-36
  ]
}

resource "intersight_fabric_eth_network_group_policy" "fabric_eth_network_group_policy_a" {
  name        = "${var.policy_prefix}-fi-a-eth_network_group-1"
  description = "VLAN Group listing allowed on Uplinks"
  vlan_settings {
    native_vlan   = 1
    allowed_vlans = var.switch_vlans_6536
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
    allowed_vlans = var.switch_vlans_6536
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
# END OF   6536 Switch Port Policies
# =============================================================================
