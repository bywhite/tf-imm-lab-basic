# =============================================================================
# IMC Local User Policies
# -----------------------------------------------------------------------------

# Consumed by Server Profiles or Sever Templates with:
  # IMC User Policy  
#   policy_bucket {
#     moid = intersight_iam_end_point_user_policy.pod_user_policy_1.moid
#     object_type = "iam.EndPointUserPolicy"
#   }

# Set "user_policy_moid" Variable for module and pass:  intersight_iam_end_point_user_policy.pod_user_policy_1.moid


## Standard Local User Policy for all local IMC users
resource "intersight_iam_end_point_user_policy" "pod_user_policy_1"  {
  description     = "Local IMC User Policy"
  name            = "${local.pod_policy_prefix}-imc-user-policy1"
  password_properties {
    enforce_strong_password  = false
    enable_password_expiry   = false
    password_expiry_duration = 90
    password_history         = 0
    notification_period      = 15
    grace_period             = 0
    object_type              = "iam.EndPointPasswordProperties"
  }
 organization {
   moid        = local.org_moid
   object_type = "organization.Organization"
 }
 dynamic "tags" {
   for_each = local.pod_tags
   content {
     key   = tags.value.key
     value = tags.value.value
   }
 }
}

##  Admin user
# This resource is a user that will be added to the policy.
resource "intersight_iam_end_point_user" "admin1" {
  name = "admin"
  organization {
    moid = local.org_moid
   object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = local.pod_tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# This data source retrieves a system built-in role that we want to assign to the admin user.
data "intersight_iam_end_point_role" "imc_admin" {
  name      = "admin"
  role_type = "endpoint-admin"
  type      = "IMC"
}

# This resource adds the user to the policy using the role we retrieved.
# Notably, the password is set in this resource and NOT in the user resource above.
resource "intersight_iam_end_point_user_role" "admin1" {
  enabled  = true
  password = var.imc_admin_password
  end_point_user {
    moid = intersight_iam_end_point_user.admin1.moid
  }
  end_point_user_policy {
    moid = intersight_iam_end_point_user_policy.pod_user_policy_1.moid
  }
  end_point_role {
    moid = data.intersight_iam_end_point_role.imc_admin.results[0].moid
  
  }
  dynamic "tags" {
    for_each = local.pod_tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  depends_on = [
    intersight_iam_end_point_user.admin1, intersight_iam_end_point_user_policy.pod_user_policy_1
  ]
}

## Example Read Only user
# This resource is a user that will be added to the policy.
resource "intersight_iam_end_point_user" "ro_user1" {
  name = "ro-user1"

  organization {
    moid = local.org_moid
   object_type = "organization.Organization"
  }
 dynamic "tags" {
   for_each = local.pod_tags
   content {
     key   = tags.value.key
     value = tags.value.value
   }
 }
}

# This data source retrieves a system built-in role that we want to assign to the user.
data "intersight_iam_end_point_role" "imc_readonly" {
  name      = "readonly"
  role_type = "endpoint-readonly"
  type      = "IMC"
}

# This user gets a random password that can be reset later
resource "random_password" "example_password" {
  length  = 16
  special = false
}

# This resource adds the user to the policy using the role we retrieved.
# Notably, the password is set in this resource and NOT in the user resource above.
resource "intersight_iam_end_point_user_role" "ro_user1" {
  enabled  = true
  password = var.imc_admin_password
  # Alternatively, we could assign a random passwrod to be changed later
  # password = random_password.example_password.result
  end_point_user {
    moid = intersight_iam_end_point_user.ro_user1.moid
  }
  end_point_user_policy {
    moid = intersight_iam_end_point_user_policy.pod_user_policy_1.moid
  }
  end_point_role {
    moid = data.intersight_iam_end_point_role.imc_readonly.results[0].moid
  }
 dynamic "tags" {
   for_each = local.pod_tags
   content {
     key   = tags.value.key
     value = tags.value.value
   }
 }
}
