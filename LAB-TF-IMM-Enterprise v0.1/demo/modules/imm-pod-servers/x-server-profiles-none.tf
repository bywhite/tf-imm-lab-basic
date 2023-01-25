# =================== DO NOT USE =============================================
# Create Server Profiles from a Server Template
#  - Bulk Managed Object Cloner
#
# This resource has significant limitations, but it does work.
# It can be used to create profiles that are attached to templates, but it cannot delete them.
# Terraform will delete them from the state but also warn that they cannot be deleted from Intersight.
# This resource cannot tell if the created profiles have actually been deleted due to the (necessary) lifecycle block.
# Care must be taken if making changes to code or variables that will result in the deletion of
# such resources due to these limitations.
# -----------------------------------------------------------------------------

# resource "intersight_bulk_mo_cloner" "server_profile_clones" {
#   # this will derive five profiles due to the way the range function works...
#   for_each = toset(formatlist("%s", range(1, var.server_count + 1)))

#   sources {
#     object_type = "server.ProfileTemplate"
#     moid        = intersight_server_profile_template.server_template_1.moid
#   }

#   targets {
#     object_type = "server.Profile"
#     additional_properties = jsonencode({
#       Name = format("${var.server_policy_prefix}-server-%s", each.key)
#     })
#   }

#   lifecycle {
#     ignore_changes = all # This is required for this resource type
#   }

# }



#### Alternative method to derive server profiles is to create and then Merge server template values

# This resource has significant limitations, but it does work.
# It can be used to create profiles that are attached to templates, but it cannot delete them.
# Terraform will delete them from the state but also warn that they cannot be deleted from Intersight.
# This resource cannot tell if the created profiles have actually been deleted due to the (necessary) lifecycle block.
# Care must be taken if making changes to code or variables that will result in the deletion of
# such resources due to these limitations.

# resource "intersight_bulk_mo_merger" "merge-server-config" {
#   count = var.server_count

#   organization {
#     moid        = var.organization
#     object_type = "organization.Organization"
#   }

#   sources {
#     object_type = "server.ProfileTemplate"
#     moid        = intersight_server_profile_template.server_template_1.moid
#   }

#   targets {
#     object_type = "server.Profile"
#     moid        = intersight_server_profile.server_profile_list[count.index].moid
#    # moid       = intersight_server_profile.server_profile_list[3].moid
#   }

#   merge_action = "Merge"

#   lifecycle {
#     ignore_changes = all # This is required for this resource type
#   }

#   depends_on = [
#     intersight_server_profile_template.server_template_1
#   ]

# }


# # DO NOT USE SERVER PROFILES - ISSUES WITH TF VS TEMPLATE CHANGE CONFLICTS
# # =============================================================================
# # Server Profiles from locally defined server template
# # -----------------------------------------------------------------------------
# # Reference: https://registry.terraform.io/providers/CiscoDevNet/Intersight/latest/docs/resources/bios_policy


# resource "intersight_server_profile" "server_profile_list" {
#   # Will add Count to create multiple instances and use index to change server names
#   count = var.server_count

#   name                   = "${var.server_policy_prefix}-server-${count.index + 1}"
#   # description          = var.description        # Set by template
#   # action               = "No-op"                # Set by template
#   server_assignment_mode = "None"                 #options: "POOL" "Static" "None"
#   # target_platform      = "FIAttached"           # Set by template
#   type = "instance"


#   src_template {
#       moid = intersight_server_profile_template.server_template_1.moid
#       object_type = "server.ProfileTemplate"
#     }

#   organization {
#     moid        = var.organization
#     object_type = "organization.Organization"
#   }

# #   dynamic "associated_server_pool" {
# #     for_each = var.associated_server_pool
# #     content {
# #       moid        = assigned_server.value.moid
# #       object_type = "resourcepool.Pool"
# #     }
# #   }

# #   dynamic "assigned_server" {
# #     for_each = var.assigned_server
# #     content {
# #       moid        = assigned_server.value.moid
# #       object_type = assigned_server.value.object_type
# #     }
# #   }

#   # dynamic "tags" {
#   #   for_each = var.tags
#   #   content {
#   #     key   = tags.value.key
#   #     value = tags.value.value
#   #   }
#   # }

#   depends_on = [
#     intersight_server_profile_template.server_template_1
#   ]
# }

