# =============================================================================
# vNic Related Server Policies
#  - vNic FC QoS Policy
#  - vNic FC Adapter Policy (adapter tuning)
#  - vNic FC Interface Policy (VSAN, WWPN, QoS, etc)
# -----------------------------------------------------------------------------


# =============================================================================
# vnic FC QoS Policy
# -----------------------------------------------------------------------------
# Replaced by a Pod-wide object moid
# resource "intersight_vnic_fc_qos_policy" "v_fc_qos1" {
#   name                = "${var.server_policy_prefix}-fc-qos1"
#   description         = var.description
#   burst               = 10240
#   rate_limit          = 0
#   cos                 = 3
#   max_data_field_size = 2112
#   organization {
#     object_type = "organization.Organization"
#     moid        = var.organization
#   }
# }


# ===============================================================================
# vnic FC Adapter Policy      HBA Adapter Settings  
## These values need updating based on Storage Platform, OS & workload
# -------------------------------------------------------------------------------
resource "intersight_vnic_fc_adapter_policy" "fc_adapter" {
  name                = "${var.server_policy_prefix}-fc-adapter-1"
  description         = var.description
  error_detection_timeout     = 2000
  io_throttle_count           = 256
  lun_count                   = 1024
  lun_queue_depth             = 254
  resource_allocation_timeout = 10000
  organization {
    moid        = var.organization
    object_type = "organization.Organization"
  }
  error_recovery_settings {
    enabled           = false
    io_retry_count    = 255
    io_retry_timeout  = 50
    link_down_timeout = 240000
    port_down_timeout = 240000
    object_type       = "vnic.FcErrorRecoverySettings"
  }
  flogi_settings {
    retries     = 8
    timeout     = 4000
    object_type = "vnic.FlogiSettings"
  }
  interrupt_settings {
    mode        = "MSIx"
    object_type = "vnic.FcInterruptSettings"
  }
  plogi_settings {
    retries     = 8
    timeout     = 20000
    object_type = "vnic.PlogiSettings"
  }
  rx_queue_settings {
    ring_size   = 128
    object_type = "vnic.FcQueueSettings"
  }
  tx_queue_settings {
    ring_size   = 128
    object_type = "vnic.FcQueueSettings"
  }
  scsi_queue_settings {
    nr_count    = 8
    ring_size   = 152
    object_type = "vnic.ScsiQueueSettings"
  }
}


# =============================================================================
# vnic FC Interface objects  fc0, fc1, etc.
# -----------------------------------------------------------------------------
resource "intersight_vnic_fc_if" "fc_if" { 
  for_each = var.vhba_vsan_sets  
  # each.value["vhba_name"]  each.value["vsan_moid"]  each.value["switch_id"]   each.value["pci_order"]
  name            = each.value["vhba_name"]
  order           = each.value["pci_order"]   # PCI Link order must be unique across all vNic's and vHBA's
  placement {
    id            = "1"
    auto_slot_id  = false
    pci_link      = 0
    auto_pci_link = false
    uplink        = 0
    switch_id     = each.value["switch_id"]
    object_type   = "vnic.PlacementSettings"
  }
  persistent_bindings = true
  wwpn_address_type   = "POOL"
  wwpn_pool {
    moid        = each.value["wwpn_pool_moid"]
    object_type = "fcpool.Pool"
  }
  san_connectivity_policy {
    moid        = intersight_vnic_san_connectivity_policy.vnic_san_con_1.moid
    object_type = "vnic.SanConnectivityPolicy"
  }
  fc_network_policy {
    # moid        = intersight_vnic_fc_network_policy.v_fc_network_a1.moid
    moid        = each.value["vsan_moid"]
    object_type = "vnic.FcNetworkPolicy"
  }
  fc_adapter_policy {
    moid        = intersight_vnic_fc_adapter_policy.fc_adapter.moid
    object_type = "vnic.FcAdapterPolicy"
  }
  fc_qos_policy {
    # moid        = intersight_vnic_fc_qos_policy.v_fc_qos1.moid
    moid = each.value["qos_moid"]
    object_type = "vnic.FcQosPolicy"
  }
}
