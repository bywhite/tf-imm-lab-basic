# ==========================================================================================
# The purpose of this lab is to create multiple Chassis Profiles
# 
# ------------------------------------------------------------------------------------------


terraform {

    required_providers {
        intersight = {
            source = "CiscoDevNet/intersight"
            version = "=1.0.34"
        }
    }
}

provider "intersight" {
  apikey    = var.apikey
  secretkey = var.secretkey
  endpoint  = "https://intersight.com"
}

data "intersight_organization_organization" "my_org" {
    name = "demo-tf"
}


# ****************************************************************************
# ========!=================!====================!==================!=========
# ================!=================!====================!====================
# ========!=================!====================!==================!=========
# * * * * * * * * *       BEGIN  LAB 5  SECTION              * * * * * * * * *


# Additional "Local" varibles have been added to assist you with this module
# Additional "Output" variables have also been added to provide external visibility
# Due to this 'head start', this module will not run until you complete the lab
#         Take a couple minutes to review the locals.tf contents


# In the Chassis Profile code, use "for_each" to create multiple chassis profiles
#  with instances for each value in the "local.chassis_index_set" local variable
#  Also change the profile "name" to append "${each.value}" instead of the "1"
#  The profile name's must be unique in Intersight - appending the index does this
# Reference:  https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
/*  HINT:

  for_each        = local.chassis_index_set

  name            = "chassis_profile${each.value}"
 
*/

# Next update every policy that is associated with the chassis profile with a
# dynamic "profiles" block with for_each instead of the simple "profiles" block
# This adds each of the chassis profile objects in the chassis_9508_profile array
# Reference: https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks
/*  HINT

  dynamic "profiles" {
    for_each = local.chassis_profile_moids
    content {
      moid        = profiles.value
      object_type = "chassis.Profile"
    }
  }

 *** OR **** 

  dynamic "profiles" {
    for_each = intersight_chassis_profile.chassis_9508_profile
    content {
      moid        = profiles.value.id
      object_type = "chassis.Profile"
    }
  }

*/




# ========!=================!====================!==================!=========
# ================!=================!====================!=====================
# ========!=================!====================!==================!=========
# * * *  Before Proceeding further, test your code * * * 

#<<<<<  Run Terraform init and Terraform plan when ready     >>>>>>
#<<<<<  If successful, run Terraform apply and enter yes     >>>>>>
#<<<<<  If successful, run Terraform apply a second time     >>>>>>
#<<<<<  Check your new creation using the Intersight GUI     >>>>>>
# Verify that your chassis Profile is associated with policies



#<<<<<  Run       Terraform destroy      * when instructed   >>>>>>
