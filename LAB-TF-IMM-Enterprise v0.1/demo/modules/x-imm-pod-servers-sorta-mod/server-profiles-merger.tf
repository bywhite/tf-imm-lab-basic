# This resource has significant limitations, but it does work.
# It can be used to create profiles that are attached to templates, but it cannot delete them.
# Terraform will delete them from the state but also warn that they cannot be deleted from Intersight.
# This resource cannot tell if the created profiles have actually been deleted due to the (necessary) lifecycle block.
# Care must be taken if making changes to code or variables that will result in the deletion of
# such resources due to these limitations.

# resource "intersight_bulk_mo_merger" "merge-template-config" {
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

#   merge_action = "Replace"
#   #  merge_action = "Merge"

#   lifecycle {
#     ignore_changes = all # This is required for this resource type
#   }

#   depends_on = [
#     intersight_server_profile_template.server_template_1, intersight_server_profile.server_profile_list
#   ]
# }
