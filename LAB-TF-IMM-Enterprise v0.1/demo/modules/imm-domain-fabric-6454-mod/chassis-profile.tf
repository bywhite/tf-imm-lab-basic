# =============================================================================
#  This file creates the Chassis Profile
#  Used by: Chassis related policies
# -----------------------------------------------------------------------------

# =============================================================================
# Chassis Profile Creation
# -----------------------------------------------------------------------------
resource "intersight_chassis_profile" "chassis_9508_profile" {
  for_each       = local.chassis_index_set
  name            = "${var.policy_prefix}-chassis-${each.value}"
  description     = "9508 chassis profile"
  type            = "instance"
  target_platform = "FIAttached"
  action          = "No-op"     #Options: Delete,Deploy,Ready,No-op,Unassign,Validate
  #iom_profiles    = {  }
  config_context {
    object_type    = "policy.ConfigContext"
    control_action = "No-op" # Options: No-op, ConfigChange, Deploy, Unbind
    error_state    = ""      # Option: Validation-error
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
