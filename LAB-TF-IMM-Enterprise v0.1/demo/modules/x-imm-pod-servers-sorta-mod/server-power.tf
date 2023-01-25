# =============================================================================
# Power Related Server Policies
#  - Power Policy
# -----------------------------------------------------------------------------

# =============================================================================
# Server Power Policy
# -----------------------------------------------------------------------------
resource "intersight_power_policy" "server_power_x" {
 #may need variables for power_priority  and use var in name "med"
  name        = "${var.server_policy_prefix}-server-power-medium"
  description              = var.description
  power_priority = "Medium"
  power_profiling = "Enabled"
  power_restore_state = "LastState"
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
