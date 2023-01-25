# ==========================================================================================
# The purpose of this module is to create a chassis profile with required policies and pool
# This file initializes required external resources
# 
# ------------------------------------------------------------------------------------------
# IMM Code Examples Can Be Found at:
# https://github.com/jerewill-cisco?tab=repositories
# https://github.com/bywhite/tf-imm-pod-example-code
# https://github.com/terraform-cisco-modules/terraform-intersight-imm/tree/master/modules
# https://github.com/scotttyso/terraform-intersight-easy-imm
# ------------------------------------------------------------------------------------------


# Terraform Providers required for our root module

terraform {

    required_providers {
        intersight = {
            source = "CiscoDevNet/intersight"
            version = ">=1.0.34"
        }
    }
}

provider "intersight" {
    apikey = var.apikey
    secretkey = var.secretkey
    endpoint = "https://intersight.com"
}

#The target Intersight Organization should be created manually in Intersight
# Example Use:  org_moid = data.intersight_organization_organization.my_org.id
data "intersight_organization_organization" "my_org" {
    name = "default"
}



# ****************************************************************************
# ========!=================!====================!==================!=========
# ================!=================!====================!====================
# ========!=================!====================!==================!=========
# * * * * * * * * *      BEGIN   LAB 6  SECTION              * * * * * * * * *


# Modules (sub-modules & remote modules) is how TF leverages "Re-Usable Code"
# The "DRY" best practices for programming means "Don't Repeat Yourself"
# When the same code block needs to be repeated, instead of copying the code
# and pasting it elsewhere multiple times, we convert it to a Module so that
# it can be reused multiple times from multiple sections of our code 

# The IP Pools can be used for the Chassis IMC and the Server Template IMC policies
# so an IP Pools module makes sense to reduse duplicating code.
# There are many opportunities to re-use code in Terraform for Intersight.

# In this Lab we created a sub-folder "modules" where we will move code to be shared
# as a module.  In the modules folder, we created a folder for the pools module: pools-mod 



# Lab Instructions: 

# -----------------------------------------------------------------------------------
# Step 1:     ----------------------------------------------------------------------
# First, move (mv) the pools.tf file to the ./modules/pools-mod/ sub-folder
# Rename pools.tf to main-pools.tf  so we know it is the main code in the module

# Note, there are optional files already added to the module folder
# These are the basic files (best practices) that you would find in a TF module
# Take a look at the Module's README.md file


# -----------------------------------------------------------------------------------
# Step 2:      ----------------------------------------------------------------------
# We need to call the module we just created to create the needed IP Pool
# We can call the module with a module block of code:
# Reference:  https://developer.hashicorp.com/terraform/language/modules/syntax

# We will label we assign to this module is "ip_pool1"
# The source folder for the module code is in the local directory structure
# We can add input variables in the module call and then define them in the
#  source module's "variables.tf" file
# We added an input variable "chassis_9508_count" and will set it to our existing
# local variable value "local.chassis_9508_count" that is defined in locals.tf
# Next we need to add the chassis_9508_count input variable in the pools module's variables.tf file

module "ip_pool1" {
  source = "./modules/pools-mod"

  organization = local.org_moid
  apikey       = var.apikey
  secretkey    = var.secretkey
}


# -----------------------------------------------------------------------------------
# Step 3     ----------------------------------------------------------------------
#  Add the following input variable code block to the ./modules/pools-mod/variables.tf file
/*

variable "organization" {
  type = string
  description = "Intersight Org to create pools in"
}

*/

# Next in the ./modules/pools-mod/main-pools.tf "Organization" code block, substitue the old
#  local.org_moid   variable with the new input variable:  var.organization



# -----------------------------------------------------------------------------------
# Step 4     ----------------------------------------------------------------------
#  That will create the pool, but we need the MOID to be able to use it
#  Add the following output varible code block to the ./modules/pools-mod/outputs.tf file
/*

output "ip_pool_chassis_moid" {
  description = "moid of the IP Pool for Chassis IMC Access Policy"
  value       = intersight_ippool_pool.ippool_pool_chassis.moid
}

*/
# ** REPEAT the same process to create the ip_pool_chassis_name  output from  ***
#      intersight_ippool_pool.ippool_pool_chassis.name



# -----------------------------------------------------------------------------------
# Step 5     ----------------------------------------------------------------------
#  Now that we have the IP Pool module output:    module.ip_pool1.ip_pool_chassis_moid
#  We need to use it in the resource "intersight_access_policy" "chassis_imc_access"
#    for the inband_ip_pool code section's "moid = "  
#  Replace the old 
#          moid        = intersight_ippool_pool.ippool_pool_chassis.moid
# with our new module output variable
#          moid        =  module.ip_pool1.ip_pool_chassis_moid

# If you run into an error when running this (probably due to dependency mappings)
# Add this depends_on statement that indicates to TF that we need to run the module
#   before we run that particular resource block

  # depends_on = [
  #   module.ip_pool1
  # ]



# -----------------------------------------------------------------------------------
# LAST STEP      ----------------------------------------------------------------------
# We added Output.tf variables to the module's  ./modules/pools-mod/outputs.tf file
# No let's kick it up one more level and add to our "root" module's outputs.tf file
#  NOTE: It's not the same variable.  Instead of the "Resource" attribute, we need the
#        Module's Output Variable:      module.ip_pool1.ip_pool_chassis_moid 
#                            and :      module.ip_pool1.ip_pool_chassis_name

/*

output "ip_pool_chassis_moid" {
  description = "moid of the IP Pool for Chassis IMC Access Policy"
  value       = module.ip_pool1.ip_pool_chassis_moid
}

*/
# ** REPEAT for the chassis IP Pool "name" Output Variable  ***
#      module.ip_pool1.ip_pool_chassis_name




# ========!=================!====================!==================!=========
# ================!=================!====================!=====================
# ========!=================!====================!==================!=========
# * * *  Before Proceeding further, test your code * * * 

#<<<<<  Run Terraform init and Terraform plan when ready     >>>>>>
#<<<<<  If successful, run Terraform apply and enter yes     >>>>>>
#<<<<<  If successful, run Terraform apply a second time     >>>>>>
#<<<<<  Check your new creation using the Intersight GUI     >>>>>>

# Explore the terraform state file for the objects you have created
#   terraform state list
#   terraform state show 'intersight_power_policy.chassis_9508_power'
#   terraform state show 'intersight_chassis_profile.chassis_9508_profile["1"]' 
#   terraform show




#<<<<<  Run       Terraform destroy   if you want to clean up   >>>>>>