# ==========================================================================================
# The purpose of this set of labs is to create a chassis profile with required policies and pool
# This lab is intended to establish a connection with Intersight using its Terraform provider
# This code is intended to run with Terraform locally installed with Intersight.com access
# The labs require an Intersight API v2 Key & Secret with an Intersight Org named "demo-tf"
# 
# ------------------------------------------------------------------------------------------
# IMM Code Examples Can Be Found at:
# https://github.com/jerewill-cisco?tab=repositories
# https://github.com/bywhite/tf-imm-pod-example-code
# https://github.com/terraform-cisco-modules/terraform-intersight-imm/tree/master/modules
# https://github.com/scotttyso/terraform-intersight-easy-imm
# ------------------------------------------------------------------------------------------

# We start wiht defining the Terraform Providers required for our main module
# Varibles are used to allow us to pass in sensitive data and keep secrets external to our code

terraform {

  #Setting required version "=" to eliminate any future adverse behavior without testing first
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = "=1.0.34"
    }
  }
}

provider "intersight" {
  apikey    = var.apikey
  secretkey = var.secretkey
  endpoint  = "https://intersight.com"
}

# !! The Intersight Organization name below should be created manually before proceeding!!
data "intersight_organization_organization" "my_org" {
  name = "demo-tf"
}


# ===================== Define Local Variables  ==========================================
# We need to retrieve the Organization's Managed Object ID (moid) from Intersight so we can 
#  assign it to created objects
locals {

  org_moid = data.intersight_organization_organization.my_org.id

}


# ===================== Define Input Variables  ==========================================
# Define Input Variables
# For simplicity, it is recommended to use local OS Environment Variables to store variables
# Examples are for Mac OS, but you can use environment variables in Windows and other OS's

# Mac CLI example to set environment variable:  export TF_VAR_<variable_name>=<value>
# Terraform uses the environment variable prefix "TF_VAR_" to identify its variables
# To use environment variables, they must be pre-defined in a "variable" code block in your code

# Mac:        export TF_VAR_apikey=1234567890/23456abcd1355q29
variable "apikey" {
  description = "API key ID for Intersight account"
  type    = string
}

# Mac:
#         export TF_VAR_secretkey=`cat ~/Downloads/SecretKey.txt` 
#                          Note:  ^  the two backticks above are not the same as single quotes ` vs '
# the back-tic tells the command line interpreter to "interpolate" the code within the backtics and insert its output
variable "secretkey" {
  description = "secret key for Intersight API vsn 2"
  type    = string
  sensitive   = true
}

# Run "env" from the CLI to verify the TF_VAR_apikey and TF_VAR_secretkey are set with the correct values
# If not, re-run the export commands
# If you are still having problems setting environment variables, verify you are using back-tics and no quotes


# ===================== Define Output Variables  =========================================
# Define Output Variables to be used outside our module
# Outputs persist in the state file and can be referenced externally
output "my_org" {
  value   = data.intersight_organization_organization.my_org.name
  description = "My Intersight Organization Name"
  sensitive = false
}
# ===================== Start Code Resource Section  =====================================


#  Now we will run commands to test our code

# Run:  terraform fmt
#       Note how the formatting has been cleaned up for you in your main.tf
# Run: terraform version

# Run:  terraform init
# Run:  terraform plan
# Run:  terraform apply 
#          when prompted enter: yes

# With the apply completed, we now have a state file, let's see what's in it
# Run:  terraform show
# Run:  terraform state list
# Run:  terraform state show data.intersight_organization_organization.my_org
# Run:  terraform output
# Run:  terraform output my_org

# More on Terraform State: https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa
# Terraform Command Cheat Sheet: https://spacelift.io/blog/terraform-commands-cheat-sheet




#<<<<<  If successful, run Terraform apply a second time     >>>>>>