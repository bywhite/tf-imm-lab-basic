# ==========================================================================================
# Chassis profiles
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/chassis_profile
# ------------------------------------------------------------------------------------------


# Do not use policy buckets with this profile
# This resource will be changed from a single instance to an array of instances
resource "intersight_chassis_profile" "chassis_9508_profile" {
  name            = "chassis_profile1"
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

