# =============================================================================
# vNic Related Server Policies
#  - QoS Policy
#  - Eth Adapter Policy (adapter tuning)
#  - vNic Eth Interface Policy
# -----------------------------------------------------------------------------


# Need Pod wide adapter QoS settings and pass in qos_moid for each adapter (need to set pod wide Domain CoS to match)
resource "intersight_vnic_eth_qos_policy" "v_eth_qos1" {
  name           = "${var.server_policy_prefix}-vnic-eth-qos"
  description    = var.description
  mtu            = 1500
  rate_limit     = 0
  cos            = 0
  burst          = 1024
  priority       = "Best Effort"
  trust_host_cos = false
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

# this policy is actually quite complex but we are taking all the defaults
# Adapter can be tuned for VMware vs Windows Bare Metal vs other (EX: tx-offload)
# could add conditional for creation based on nic_optimized_for = "vmw"
resource "intersight_vnic_eth_adapter_policy" "v_eth_adapter1" {
  name        = "${var.server_policy_prefix}-vnic-eth-adapter"
  description = var.description
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
# vNICs
# -----------------------------------------------------------------------------
resource "intersight_vnic_eth_if" "eth_if" {
  for_each = var.vnic_vlan_sets
# each.value["vnic_name"]  each.value["native_vlan"]  each.value["vlan_range"] each.value["switch_id"]

  # other: int_name, switch_id(A/B), vnic_lan_moid[*], adapter_pol_moid[*], qos_moid[*], net_grp_moid[*], ncp_moid  
  name             = each.value["vnic_name"]   # was "${var.server_policy_prefix}-${each.value["vnic_name"]}"
  order            = each.value["pci_order"]   # must be unique across all vNic and vHBA
  failover_enabled = false
  mac_address_type = "POOL"
  mac_pool {
    moid = var.mac_pool_moid
  }
  placement {
    id        = "MLOM"                       # MLOM is same as slot 1 Range is (1-15) and MLOM
    pci_link  = 0                            # Ignored value for all but VIC1380
    switch_id = each.value["switch_id"]
    # uplink    = 0                          #rack servers only
  }
  cdn {
    value     = each.value["vnic_name"]    # was "${var.server_policy_prefix}-${each.value["vnic_name"]}"
    nr_source = "vnic"
  }
  usnic_settings {
    cos      = 5
    nr_count = 0
  }
  vmq_settings {
    enabled             = false
    multi_queue_support = false
    num_interrupts      = 16
    num_vmqs            = 4
  }
  lan_connectivity_policy {   # Groups eth[*] interfaces together and sets FI-attached
    moid        = intersight_vnic_lan_connectivity_policy.vnic_lan_1.id
    object_type = "vnic.LanConnectivityPolicy"
  }
  eth_adapter_policy {        # Provides for adapter tuning to workload
    moid = intersight_vnic_eth_adapter_policy.v_eth_adapter1.id
  }
  eth_qos_policy {            # Unique per eth[*] - Sets Class of Service and MTU
    moid = intersight_vnic_eth_qos_policy.v_eth_qos1.id
  }
  fabric_eth_network_group_policy {   # Unique per eth[*] - Sets VLAN list (2,4,7,1000-1011)
    moid = intersight_fabric_eth_network_group_policy.fabric_eth_network_group_policy1[each.value["vnic_name"]].moid
  }
  fabric_eth_network_control_policy {  # Sets CDP LLDP and link down behavior 
    moid = intersight_fabric_eth_network_control_policy.fabric_eth_network_control_policy1.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
