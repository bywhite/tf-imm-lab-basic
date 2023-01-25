# ==========================================================================================
# The purpose of this module is to create a chassis profile with required policies and pool
# This code is intended to run with Terraform locally installed
# The code requires an Intersight API v2 Key & Secret and Intersight Org named "default"
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
            source = "CiscoDevNet/intersight"
            version = "=1.0.34"
        }
    }
}

provider "intersight" {
    apikey = var.apikey
    secretkey = var.secretkey
    endpoint = "https://intersight.com"
}

# !! The target Intersight Organization "default" should be created manually in Intersight !!

data "intersight_organization_organization" "my_org" {
    name = "default"
}
# Don't forget to add the above Organization to your Intersight https://intersight.com


# ===================== Define Local Variables  ==========================================
# We need to retrieve the Organization Managed Object ID (moid) from Intersight so we can 
#  use it to create objects in that organization in Intersight
locals {

  org_moid = data.intersight_organization_organization.my_org.id

}


# ===================== Define Input Variables  ==========================================
# Define Input Variables
# For simplicity, it is recommended to use local OS Environment Variables to store variables
# Examples are for Mac OS, but can use environment variables of any OS

# Variables can be set with environment variables:  export TF_VAR_<variable_name>=<value>
# Terraform can import variables when prefixed by "TF_VAR_" from the OS environment (Mac/Windows/Linux) 
#  that match variable declarations within the Terraform HCL main module

# Mac:        export TF_VAR_apikey=<my-api-key>
variable "apikey" {
  description = "API key ID for Intersight account"
  type = string
}

# Mac:    export TF_VAR_secretkey=`cat ~/Downloads/SecretKey.txt` 
#                          Note:  ^  the two backticks above are not the same as single quotes ` vs '
variable "secretkey" {
  description = "secret key for Intersight API vsn 2"
  type = string
}


# ===================== Define Output Variables  =========================================
# Define Output Variables to be used outside our module
output "my_org" {
  value       = data.intersight_organization_organization.my_org.name
  description = "My Intersight Organization Name"
  sensitive   = false
}


# ===================== Start Code Resource Section  =====================================


#<<<<<  Run Terraform init and Terraform plan when ready     >>>>>>
#<<<<<  If successful, run Terraform apply and enter yes     >>>>>>

# Properly formatted code aligns all of the = signs in a block
#<<<<<  Run Terraform fmt                                    >>>>>>
#       Note how the formatting has been cleaned up for you
#<<<<<  If successful, run Terraform apply a second time     >>>>>>