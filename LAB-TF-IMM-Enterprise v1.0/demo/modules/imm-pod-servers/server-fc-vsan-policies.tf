# =============================================================================
#  Server SAN Related  Policies
#  - SAN Connectivity Policy (WWNN)
#  - FC Network Policy now defined pod_wide and moid is passed via
#    input variable vhba_vsan_sets to be assigned to interfaces
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
}

