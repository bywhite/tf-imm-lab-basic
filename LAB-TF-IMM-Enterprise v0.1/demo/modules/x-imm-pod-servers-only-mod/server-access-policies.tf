# =============================================================================
#  Server Access Related  Policies
#  - Access Policy
#  - Serial Over LAN
#  - IPMI Over LAN
#  - Device Connector Policy
#  - Local User
#  - Certificate Management
# -----------------------------------------------------------------------------



# =============================================================================
# IMC Access
# -----------------------------------------------------------------------------

resource "intersight_access_policy" "access_1" {
  name        = "${var.server_policy_prefix}-imc-access-policy-1"
  description = var.description
  inband_vlan = var.imc_access_vlan
  inband_ip_pool {
    object_type  = "ippool.Pool"
    #moid        = intersight_ippool_pool.ippool_pool1.moid
    moid         = var.imc_ip_pool_moid
  }
  organization {
    moid        = var.organization
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# =============================================================================
# Serial Over LAN (optional)
# -----------------------------------------------------------------------------

resource "intersight_sol_policy" "sol1" {
 name        = "${var.server_policy_prefix}-sol-off-policy-1"
 description = var.description
 enabled     = false
 baud_rate   = 9600
 com_port    = "com1"
 ssh_port    = 1096
 organization {
   moid        = var.organization
   object_type = "organization.Organization"
 }
 dynamic "tags" {
   for_each = var.tags
   content {
     key   = tags.value.key
     value = tags.value.value
   }
 }
}


# =============================================================================
# IPMI over LAN (optional)   Used by Server Profile Template
# -----------------------------------------------------------------------------

resource "intersight_ipmioverlan_policy" "ipmi1" {
 description = var.description
 enabled     = false
 name        = "${var.server_policy_prefix}-ipmi-disabled"
 organization {
   moid        = var.organization
   object_type = "organization.Organization"
 }
 dynamic "tags" {
   for_each = var.tags
   content {
     key   = tags.value.key
     value = tags.value.value
   }
 }
}


# =============================================================================
# Device Connector Policy (optional)
# -----------------------------------------------------------------------------

# resource "intersight_deviceconnector_policy" "deviceconnector1" {
#  description     = var.description
#  lockout_enabled = true
#  name            = "${var.server_policy_prefix}-device-connector"
#  organization {
#    moid        = var.organization
#    object_type = "organization.Organization"
#  }
#  dynamic "tags" {
#    for_each = var.tags
#    content {
#      key   = tags.value.key
#      value = tags.value.value
#    }
#  }
# }

# resource "intersight_iam_end_point_user_policy" "imc_user1"  {
#   description     = var.description
#   name            = "${var.server_policy_prefix}-imc-user-policy1"
#   password_properties {
#     enforce_strong_password  = false
#     enable_password_expiry   = false
#     password_expiry_duration = 90
#     password_history         = 0
#     notification_period      = 15
#     grace_period             = 0
#     object_type              = "iam.EndPointPasswordProperties"
#   }
#   # end_point_user_roles {
#   #   object_type  = "iam.EndPointUserRole"
#   #   moid         = intersight_iam_end_point_user_role.
#   # }
#  organization {
#    moid        = var.organization
#    object_type = "organization.Organization"
#  }
#  dynamic "tags" {
#    for_each = var.tags
#    content {
#      key   = tags.value.key
#      value = tags.value.value
#    }
#  }

# }

# # =============================================================================
# # Local User Policies
# # -----------------------------------------------------------------------------

# ## Standard Local User Policy for all local IMC users
# resource "intersight_iam_end_point_user_policy" "user_policy_1"  {
#   description     = var.description
#   name            = "${var.server_policy_prefix}-imc-user-policy1"
#   password_properties {
#     enforce_strong_password  = false
#     enable_password_expiry   = false
#     password_expiry_duration = 90
#     password_history         = 0
#     notification_period      = 15
#     grace_period             = 0
#     object_type              = "iam.EndPointPasswordProperties"
#   }
#  organization {
#    moid        = var.organization
#    object_type = "organization.Organization"
#  }
#  dynamic "tags" {
#    for_each = var.tags
#    content {
#      key   = tags.value.key
#      value = tags.value.value
#    }
#  }
# }

# ##  Admin user
# # This resource is a user that will be added to the policy.
# resource "intersight_iam_end_point_user" "admin" {
#   name = "admin"
#   organization {
#     moid = var.organization
#    object_type = "organization.Organization"
#   }
#   dynamic "tags" {
#     for_each = var.tags
#     content {
#       key   = tags.value.key
#       value = tags.value.value
#     }
#   }
# }

# # This data source retrieves a system built-in role that we want to assign to the admin user.
# data "intersight_iam_end_point_role" "imc_admin" {
#   name      = "admin"
#   role_type = "endpoint-admin"
#   type      = "IMC"
# }

# # This resource adds the user to the policy using the role we retrieved.
# # Notably, the password is set in this resource and NOT in the user resource above.
# resource "intersight_iam_end_point_user_role" "admin" {
#   enabled  = true
#   password = var.server_imc_admin_password
#   end_point_user {
#     moid = intersight_iam_end_point_user.admin.moid
#   }
#   end_point_user_policy {
#     moid = intersight_iam_end_point_user_policy.user_policy_1.moid
#   }
#   end_point_role {
#     # moid = data.intersight_iam_end_point_role.imc_admin.results[0].moid
#     moid = local.local_user_admin_moid
#   }
#   dynamic "tags" {
#     for_each = var.tags
#     content {
#       key   = tags.value.key
#       value = tags.value.value
#     }
#   }
#   depends_on = [
#     intersight_iam_end_point_user.admin, intersight_iam_end_point_user_policy.user_policy_1
#   ]
# }

# ## Example Read Only user
# # This resource is a user that will be added to the policy.
# resource "intersight_iam_end_point_user" "ro_user1" {
#   name = "ro_user1"

#   organization {
#     moid = var.organization
#    object_type = "organization.Organization"
#   }
#  dynamic "tags" {
#    for_each = var.tags
#    content {
#      key   = tags.value.key
#      value = tags.value.value
#    }
#  }
# }

# # This data source retrieves a system built-in role that we want to assign to the user.
# data "intersight_iam_end_point_role" "imc_readonly" {
#   name      = "readonly"
#   role_type = "endpoint-readonly"
#   type      = "IMC"
# }

# # This user gets a random password that can be reset later
# resource "random_password" "example_password" {
#   length  = 16
#   special = false
# }

# # This resource adds the user to the policy using the role we retrieved.
# # Notably, the password is set in this resource and NOT in the user resource above.
# resource "intersight_iam_end_point_user_role" "ro_user1" {
#   enabled  = true
#   password = var.server_imc_admin_password
#   # Alternatively, we could assign a random passwrod to be changed later
#   # password = random_password.example_password.result
#   end_point_user {
#     moid = intersight_iam_end_point_user.ro_user1.moid
#   }
#   end_point_user_policy {
#     moid = intersight_iam_end_point_user_policy.user_policy_1.moid
#   }
#   end_point_role {
#     moid = local.local_user_ro_moid
#     #moid = data.intersight_iam_end_point_role.imc_readonly.results[0].moid
#   }
#  dynamic "tags" {
#    for_each = var.tags
#    content {
#      key   = tags.value.key
#      value = tags.value.value
#    }
#  }
# }
