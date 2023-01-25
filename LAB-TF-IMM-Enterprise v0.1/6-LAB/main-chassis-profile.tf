# ==========================================================================================
# The purpose of this section is to create a chassis profile
# 
# 
# ------------------------------------------------------------------------------------------


# IMM Chassis Profile resource
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/chassis_profile
# ** Set policy alias (resource's instance name) to "chassis_9508_profile"
# ** Set "action" and "control_action" parameters to "No-op"
# ** Set "error_state" parameter to ""
# ** Set the orgainization "moid" equal to your local organization variable (local.org_moid)
# Do not use policy buckets in this exercise

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

