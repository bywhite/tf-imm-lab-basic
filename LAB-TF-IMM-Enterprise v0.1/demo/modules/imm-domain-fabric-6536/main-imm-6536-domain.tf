# =============================================================================
# This main module creates a 6536 Cluster (Domain) Profile
# Used by: switch profile's self-assignment to this cluster profile
# To use versions, add tag "v1.2.0" and from CLI: git push --follow-tags
#  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods//imm-domain-fabric-6536?ref=v1.2.0"
# -----------------------------------------------------------------------------

### FI 6536 DOMAIN Profile  (cluster_profile) ####
resource "intersight_fabric_switch_cluster_profile" "fi6536_cluster_profile" {
  name        = "${var.policy_prefix}-imm-domain"
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
