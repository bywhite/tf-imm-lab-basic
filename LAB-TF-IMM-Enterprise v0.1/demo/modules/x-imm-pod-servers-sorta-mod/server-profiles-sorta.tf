# # =============================================================================
# # Server Profiles from locally defined server template - but not bound to it
# # -----------------------------------------------------------------------------
# # Reference: https://registry.terraform.io/providers/CiscoDevNet/Intersight/latest/docs/resources/bios_policy


resource "intersight_server_profile" "server_profile_list" {
  for_each = try(local.server_name_set)
# count = var.server_count
# count = (var.server_count != null) ? 1 : 0
# for_each = local.eth_breakout_count != 0 ? var.eth_aggr_server_ports : {}

  name                   = each.value
  # description          = var.description  # Set by template
  # action               = "No-op"          # May not be needed **** / Set by template
  server_assignment_mode = "None"           # options: "POOL" "Static"
  target_platform      = "FIAttached"     # Required by Template to attach properly
  type = "instance"
  wait_for_completion = true
  organization {
    moid        = var.organization
    object_type = "organization.Organization"
  }

  # Attaching a template creates subsequent errors - profiles become Read_Only
  #    Hence subsequent resource accesses cause errors, even though no changes.
  # src_template {
  #   moid = intersight_server_profile_template.server_template_1.moid
  #   object_type = "server.ProfileTemplate"
  # }

#   dynamic "associated_server_pool" {
#     for_each = var.associated_server_pool
#     content {
#       moid        = assigned_server.value.moid
#       object_type = "resourcepool.Pool"
#     }
#   }

#   dynamic "assigned_server" {           # Used to assign a list of server moids
#     for_each = var.assigned_server
#     content {
#       moid        = assigned_server.value.moid
#       object_type = assigned_server.value.object_type
#     }
#   }

#   dynamic "tags" {            # assigned by template
#     for_each = var.tags
#     content {
#       key   = tags.value.key
#       value = tags.value.value
#     }
#   }

  depends_on = [
    intersight_server_profile_template.server_template_1
  ]
}


# This sets the initial values of the Server Profile to match the un-attached server profile template
# There is currently an issue with the Terraform Provider that prohibits proper Template/Profile behavior
resource "intersight_bulk_mo_merger" "merge-template-config" {
  for_each = try(local.server_name_set)
  # count = var.server_count
  organization {
    moid        = var.organization
    object_type = "organization.Organization"
  }
  sources {
    object_type = "server.ProfileTemplate"
    moid        = intersight_server_profile_template.server_template_1.moid
  }
  targets {
    object_type = "server.Profile"
    moid        = intersight_server_profile.server_profile_list[each.key].moid
  }
  merge_action = "Replace"
  #  merge_action = "Merge"
  lifecycle {
    ignore_changes = all # This is required for this resource type
  }
  depends_on = [
    intersight_server_profile_template.server_template_1, intersight_server_profile.server_profile_list
  ]

}
