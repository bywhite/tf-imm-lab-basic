# =============================================================================
# Network Related Server Policies
#  - Multicast Policy
#  - LAN Connectivity Policy
#  - Network Control Policy (CDP & LLDP)
#  - Network Group Policy (VLANs)
# -----------------------------------------------------------------------------


# =============================================================================
# Multicast
# -----------------------------------------------------------------------------

resource "intersight_fabric_multicast_policy" "fabric_multicast_policy_1" {
  name               = "${var.server_policy_prefix}-multicast-policy-1"
  description        = var.description
  querier_ip_address = ""
  querier_state      = "Disabled"
  snooping_state     = "Enabled"
  organization {
    moid        = var.organization
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# =============================================================================
# LAN Connectivity
# -----------------------------------------------------------------------------

resource "intersight_vnic_lan_connectivity_policy" "vnic_lan_1" {
  name                = "${var.server_policy_prefix}-lan-connectivity"
  description         = var.description
  iqn_allocation_type = "None"
  placement_mode      = "auto"
  target_platform     = "FIAttached"
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


# =============================================================================
#  Network Control Policy
# -----------------------------------------------------------------------------

# https://registry.terraform.io/providers/CiscoDevNet/Intersight/latest/docs/resources/fabric_eth_network_control_policy
resource "intersight_fabric_eth_network_control_policy" "fabric_eth_network_control_policy1" {
  name        = "${var.server_policy_prefix}-eth-network-control"
  description = var.description
  cdp_enabled = true
  forge_mac   = "allow"
  lldp_settings {
    object_type      = "fabric.LldpSettings"
    receive_enabled  = true
    transmit_enabled = true
  }
  mac_registration_mode = "allVlans"
  uplink_fail_action    = "linkDown"
  organization {
    moid = var.organization
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


# =============================================================================
#  Network Group Policy (VLANs)            -tied to each vNIC policy Ex: eth0
#  Used by "intersight_vnic_eth_if" resource to create "eth0", "eth1", etc
# -----------------------------------------------------------------------------
# https://registry.terraform.io/providers/CiscoDevNet/Intersight/latest/docs/resources/fabric_eth_network_group_policy
resource "intersight_fabric_eth_network_group_policy" "fabric_eth_network_group_policy1" {
  for_each = var.vnic_vlan_sets
# each.value["vnic_name"]  each.value["native_vlan"]  each.value["vlan_range"]  each.value["switch_id"]

  name        = "${var.server_policy_prefix}-${each.value["vnic_name"]}-network-group"
  description = var.description
  vlan_settings {
    native_vlan   = each.value["native_vlan"]
    allowed_vlans = each.value["vlan_range"]
    # allowed_vlans = join(",", values(var.uplink_vlans_6454))
  }
  organization {
    moid = var.organization
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

