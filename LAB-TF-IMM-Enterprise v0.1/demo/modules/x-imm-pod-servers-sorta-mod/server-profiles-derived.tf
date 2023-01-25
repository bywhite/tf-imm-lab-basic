
# This resource has significant limitations, but it does work.
# It can be used to create profiles that are attached to templates, but it cannot delete them.
# Terraform will delete them from the state but also warn that they cannot be deleted from Intersight.
# This resource cannot tell if the created profiles have actually been deleted due to the (necessary) lifecycle block.
# Care must be taken if making changes to code or variables that will result in the deletion of
# such resources due to these limitations.

# resource "intersight_bulk_mo_cloner" "example" {
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
