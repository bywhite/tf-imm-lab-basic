# =============================================================================
#  Server SAN Related  Policies
#  - SAN Connectivity Policy
#  - HBA Instances (fc0, fc1, fc2, fc3)
#  - FC Adapter Policy
#  - Network Policy
#  - FC QoS Policy
#  - FC Interface
# -----------------------------------------------------------------------------

# =============================================================================
# SAN Connectivity   object: "vnic.SanConnectivityPolicy"
# -----------------------------------------------------------------------------

resource "intersight_vnic_san_connectivity_policy" "vnic_san_con_1" {
  name                = "${var.server_policy_prefix}-san-connectivity"
  description         = var.description
  target_platform = "FIAttached"
  placement_mode = "auto"
  wwnn_address_type = "POOL"
  wwnn_pool {
    moid = var.wwnn_pool_moid
    object_type = "fcpool.Pool"
  }
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
#   Add all vHBA Profiles (FC Interfaces) to SAN Connectivity Policy or vice-versa
#   profiles {
#     moid        = var.profile
#     object_type = "server.Profile"
#   }
}

# ===============================================================================
# vnic FC Adapter Policy      HBA Adapter Settings  ## These values need updating
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
# vnic FC Network Policy
# -----------------------------------------------------------------------------
resource "intersight_vnic_fc_network_policy" "v_fc_network_a1" {
  name                = "${var.server_policy_prefix}-fc-network-a1"
  description         = var.description
  vsan_settings {
    id          = 100
    object_type = "vnic.VsanSettings"
  }
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }

}
resource "intersight_vnic_fc_network_policy" "v_fc_network_b1" {
  name                = "${var.server_policy_prefix}-fc-network-b1"
  description         = var.description
  vsan_settings {
    id          = 200
    object_type = "vnic.VsanSettings"
  }
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
}

# =============================================================================
# vnic FC QoS Policy
# -----------------------------------------------------------------------------
resource "intersight_vnic_fc_qos_policy" "v_fc_qos1" {
  name                = "${var.server_policy_prefix}-fc-qos1"
  description         = var.description
  burst               = 10240
  rate_limit          = 0
  cos                 = 3
  max_data_field_size = 2112
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
}

# =============================================================================
# vnic FC Interface objects  fc0  and fc1
# -----------------------------------------------------------------------------

resource "intersight_vnic_fc_if" "fc0" {
  name                = "${var.server_policy_prefix}-fc0"
  order = 2
  placement {
    id          = "1"
    auto_slot_id = false
    pci_link    = 0
    auto_pci_link = false
    uplink      = 0
    switch_id   = "A"
    object_type = "vnic.PlacementSettings"
  }
  persistent_bindings = true
  wwpn_address_type = "POOL"
  wwpn_pool {
    moid = var.wwpn_pool_b_moid
    object_type = "fcpool.Pool"
  }
  san_connectivity_policy {
    moid        = intersight_vnic_san_connectivity_policy.vnic_san_con_1.moid
    object_type = "vnic.SanConnectivityPolicy"
  }
  fc_network_policy {
    moid        = intersight_vnic_fc_network_policy.v_fc_network_b1.moid
    object_type = "vnic.FcNetworkPolicy"
  }
  fc_adapter_policy {
    moid        = intersight_vnic_fc_adapter_policy.fc_adapter.moid
    object_type = "vnic.FcAdapterPolicy"
  }
  fc_qos_policy {
    moid        = intersight_vnic_fc_qos_policy.v_fc_qos1.moid
    object_type = "vnic.FcQosPolicy"
  }
}

resource "intersight_vnic_fc_if" "fc1" {
  name                = "${var.server_policy_prefix}-fc1"
  order = 3
  placement {
    id          = "1"
    auto_slot_id = false
    pci_link    = 0
    auto_pci_link = false
    uplink      = 0
    switch_id   = "B"
    object_type = "vnic.PlacementSettings"
  }
  persistent_bindings = true
  wwpn_address_type = "POOL"
  wwpn_pool {
    moid = var.wwpn_pool_b_moid
    object_type = "fcpool.Pool"
  }
  san_connectivity_policy {
    moid        = intersight_vnic_san_connectivity_policy.vnic_san_con_1.moid
    object_type = "vnic.SanConnectivityPolicy"
  }
  fc_network_policy {
    moid        = intersight_vnic_fc_network_policy.v_fc_network_b1.moid
    object_type = "vnic.FcNetworkPolicy"
  }
  fc_adapter_policy {
    moid        = intersight_vnic_fc_adapter_policy.fc_adapter.moid
    object_type = "vnic.FcAdapterPolicy"
  }
  fc_qos_policy {
    moid        = intersight_vnic_fc_qos_policy.v_fc_qos1.moid
    object_type = "vnic.FcQosPolicy"
  }

  depends_on = [
    intersight_vnic_san_connectivity_policy.vnic_san_con_1
  ]
}
