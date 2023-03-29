# ==========================================================================================
# The purpose of this lab is to create a sub-module
# 
# ------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------
# IMM Code Examples Can Be Found at:
# https://github.com/jerewill-cisco?tab=repositories
# https://github.com/bywhite/tf-imm-pod-example-code
# https://github.com/terraform-cisco-modules/terraform-intersight-imm/tree/master/modules
# https://github.com/scotttyso/terraform-intersight-easy-imm
# ------------------------------------------------------------------------------------------


terraform {

    required_providers {
        intersight = {
            source = "CiscoDevNet/intersight"
            version = ">=1.0.34"
        }
    }
}

provider "intersight" {
  apikey    = var.apikey
  secretkey = var.secretkey
  endpoint  = "https://intersight.com"
}

data "intersight_organization_organization" "my_org" {
    name = "demo"
}



# ****************************************************************************
# ========!=================!====================!==================!=========
# ================!=================!====================!====================
# ========!=================!====================!==================!=========
# * * * * * * * * *      BEGIN   LAB 6  SECTION              * * * * * * * * *


# Modules (sub-modules & remote modules) are how TF leverages "Re-Usable Code"
# The "DRY" best practices for programming means "Don't Repeat Yourself"
# When the same code block needs to be repeated, instead of copying the code
# and pasting it elsewhere multiple times, we convert it to a Module so that
# it can be called multiple times from multiple sections of our code 

# The IP Pools can be used for the Chassis IMC and the Server Template IMC policies
# and the code repeated in each creation of a new template or chassis block of code.
# There are many opportunities to re-use code in Terraform for Intersight.

# In this Lab we created a sub-folder "modules" where we will move code to be shared
# as a module.  In the modules folder, we created a folder for the pools module: pools-mod 


# Lab Instructions: 

# -----------------------------------------------------------------------------------
# Step 1:     ----------------------------------------------------------------------
# First, move (mv) the pools.tf file to the ./modules/pools-mod/    sub-folder
# Rename the pools.tf file to main-pools.tf so we know it is the main code file

# Note, there are optional files already added to the module folder  (review the files)
# These are the basic files (best practices) that you would find in a TF module


# -----------------------------------------------------------------------------------
# Step 2:      ----------------------------------------------------------------------
# We need to call the IP Pools module we just created 
# We call the module with a module block of code:
# Reference:  https://developer.hashicorp.com/terraform/language/modules/syntax

# We will call (alias) our new module "ip_pool1"
# uncomment the following code to call the new module (remove lines with /* and */)


module "ip_pool1" {
  source = "./modules/pools-mod"

  organization = local.org_moid
  apikey       = var.apikey
  secretkey    = var.secretkey
}


# -----------------------------------------------------------------------------------
# Step 3     ----------------------------------------------------------------------
#  Verify the following input variable code block in ./modules/pools-mod/variables.tf file
/*

variable "organization" {
  type = string
  description = "Intersight Org to create pools in"
}

*/

# Next in the ./modules/pools-mod/main-pools.tf "Organization" code block, remove the old
#  "local.org_moid"   variable and use the new input variable passed to the module:  
#  "var.organization"



# -----------------------------------------------------------------------------------
# Step 4     ----------------------------------------------------------------------
#  That is enough to create the pool, but we need the MOID returned to be able to
#    associate it with the chassis policy
#  Add the following output varible code block to the ./modules/pools-mod/outputs.tf file
/*

output "ip_pool_chassis_moid" {
  description = "moid of the IP Pool for Chassis IMC Access Policy"
  value       = intersight_ippool_pool.ippool_pool_chassis.moid
}

*/
# ** REPEAT ** the same process to create the ip_pool_chassis_name  output from
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
#   before we run that particular resource block (intersight_access_policy)

  # depends_on = [
  #   module.ip_pool1
  # ]



# -----------------------------------------------------------------------------------
# LAST STEP      ----------------------------------------------------------------------
# We added Output.tf variables to the module's  ./modules/pools-mod/outputs.tf file
# Now let's kick it up one more level and add to our "root" module's outputs.tf file
#  NOTE: It's not the same variables.  Instead of the Resource's attribute, we need the
#        Module's Output Variable:      module.ip_pool1.ip_pool_chassis_moid 
#                            and :      module.ip_pool1.ip_pool_chassis_name
#
#  ** Add them with following to the outputs.tf file
/*

output "ip_pool_chassis_moid" {
  description = "moid of the IP Pool for Chassis IMC Access Policy"
  value       = module.ip_pool1.ip_pool_chassis_moid
}

*/
# ** REPEAT ** for the chassis IP Pool "name" Output Variable  ***
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



#<<<<<  Run       Terraform destroy      * when done with labs   >>>>>>