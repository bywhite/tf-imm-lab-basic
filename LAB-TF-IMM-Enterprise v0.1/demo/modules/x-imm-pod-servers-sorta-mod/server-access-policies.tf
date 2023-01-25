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
