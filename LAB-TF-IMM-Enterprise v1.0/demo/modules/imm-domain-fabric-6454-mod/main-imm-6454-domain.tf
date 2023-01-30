# =============================================================================
# This main module creates a 6454 Cluster (Domain) Profile
# Used by: switch profile's self-assignment to this cluster profile
# -----------------------------------------------------------------------------

### FI 6454 DOMAIN Profile  (cluster_profile) ####
resource "intersight_fabric_switch_cluster_profile" "fi6454_cluster_profile" {
  name        = "${var.policy_prefix}-domain"
  description = var.description
  type        = "instance"
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
# END of 6454 Switch Cluster (Domain) Profile
# -----------------------------------------------------------------------------