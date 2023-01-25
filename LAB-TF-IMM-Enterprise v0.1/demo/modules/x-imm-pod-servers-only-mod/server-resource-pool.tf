# =============================================================================
# Server Resoure Pool for servers spawned from this server profile template
# -----------------------------------------------------------------------------
# Reference: https://github.com/terraform-cisco-modules/terraform-intersight-imm/blob/master/modules/resource_pools/main.tf

resource "intersight_resourcepool_pool" "resource_pool" {
  assignment_order = "sequential"
  name        = "${var.server_policy_prefix}-srv-pool"
  description              = var.description
  pool_type        = "Static"
  resource_pool_parameters = [
    {
      additional_properties = jsonencode(
        {
          ManagementMode = "Intersight"
        }
      )
      class_id    = "resourcepool.ServerPoolParameters"
      object_type = "resourcepool.ServerPoolParameters"
    }
  ]
  resource_type = "Server"
#   selectors = [
#     {
#       additional_properties = ""
#       class_id              = "resource.Selector"
#       object_type           = "resource.Selector"
#       selector              = "/api/v1/compute/${var.server_type}?$filter=(Moid in (${local.moid_list})) and (ManagementMode eq 'Intersight')"
#     }
#  ]
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
