# ==========================================================================================
# Chassis profiles
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/chassis_profile
# ------------------------------------------------------------------------------------------


# Do not use policy buckets with this profile
# This resource uses for_each to create an array of instances
resource "intersight_chassis_profile" "chassis_9508_profile" {
  for_each       = local.chassis_index_set
  name            = "chassis_profile${each.value}"
  description     = "chassis profile"
  type            = "instance"
  target_platform = "FIAttached"
  action          = "No-op"
  config_context {
    object_type    = "policy.ConfigContext"
    control_action = "No-op"
    error_state    = ""
  }
  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }
}

