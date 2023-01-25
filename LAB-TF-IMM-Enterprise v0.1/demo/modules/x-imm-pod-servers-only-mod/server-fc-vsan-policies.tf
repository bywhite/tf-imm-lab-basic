# =============================================================================
#  Server SAN Related  Policies
#  - SAN Connectivity Policy
#  - FC Network Policy (VSAN per HBA)
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
