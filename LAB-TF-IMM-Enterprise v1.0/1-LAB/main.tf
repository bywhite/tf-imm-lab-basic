# ==========================================================================================
# The purpose of this lab is to create a chassis profile
# 
# ------------------------------------------------------------------------------------------
# IMM Code Examples Can Be Found at:
# https://github.com/jerewill-cisco?tab=repositories
# https://github.com/bywhite/tf-imm-pod-example-code
# https://github.com/terraform-cisco-modules/terraform-intersight-imm/tree/master/modules
# https://github.com/scotttyso/terraform-intersight-easy-imm
# ------------------------------------------------------------------------------------------


# Define Terraform Providers required for our main module

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
  secretkey = local.secretkey
  endpoint  = "https://intersight.com"
}

data "intersight_organization_organization" "my_org" {
    name = "demo-tf"
}


# ===================== Define Local Variables  ==========================================
locals {

  org_moid = data.intersight_organization_organization.my_org.id  
  secretkey = file("../SecretKey.txt")

}


# ===================== Define Input Variables  ==========================================
# Define Input Variables

variable "apikey" {
  description = "API key ID for Intersight account"
  type = string
}

variable "secretkey" {
  description = "secret key for Intersight API vsn 2"
  type        = string
  sensitive   = true
}


# ===================== Define Output Variables  =========================================
# Define Output Variables
output "my_org" {
  value       = data.intersight_organization_organization.my_org.name
  description = "My Intersight Organization Name"
  sensitive   = false
}


# ===================== Start Code Resource Section  =====================================

# Create an IMM Chassis Profile resource
#   Copy the reference example given and past below
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/chassis_profile
# ** Set "action" and "control_action" parameters to "No-op"
# ** Set "error_state" parameter to ""
# ** Set the orgainization "moid" equal to your local organization variable (local.org_moid)

# Paste Example Code Here:




#-----------------------------------------------------------------------------------------
#=========================================================================================
#  Now we will run commands to test our code

# Run:  terraform fmt
#       Note how the formatting has been cleaned up for you in your main.tf

# Run:  terraform init
# Run:  terraform plan
# Run:  terraform apply 
#          when prompted enter: yes

# With the apply completed, we have an updated state file
# Run:  terraform state list
# Run:  terraform state show intersight_chassis_profile.chassis_9508_profile1
#                 Note this shows the alias of the Resource, not the "name" of the profile in Intersight


# Experiment with changing the resource "chassis_profile1" on the top line to "chassis1" and run terraform apply
#  The "chassis_profile1" on the top resource line is an object alias used by terraform to track its state
#  When it is changed, you are actually destroying that object in state and creating a new one with a new name
#  If you look in Intersight you will see that the chassis "name" remains unchanged
#  However the chassis object in Intersight has a new "moid", meaning it was destroyed and recreated


#  It is very important that resource aliases do not change in your code - just the parameters of the resource

# Next try changing just the parameter "name" value on the 2nd line to "my-first-chassis" 
#   - the "name" change causes just an update, instead of a destroy/recreate as with the resource alias change
#<<<<<  Check your new chassis profile using the Intersight GUI     >>>>>>
#  In Intersight you will see that the name of the chassis has changed to the value you set for "name"
#  and the "moid" of the chassis object remains the same, meaning it was just updated, not recreated


#<<<<<  run Terraform apply a second time, there should be no changes     >>>>>>
#  When you run "terraform destroy"  it removes "my-first-chassis" from Intersight

# Run: terraform destroy
#          when prompted enter: yes