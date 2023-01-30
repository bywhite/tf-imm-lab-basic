# ==========================================================================================
# Chassis profiles
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/chassis_profile
# ------------------------------------------------------------------------------------------


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

