# ==========================================================================================
# The purpose of this module is to create a chassis profile with required policies and pool
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

#The target Intersight Organization should be created manually in Intersight
# Example Use:  org_moid = data.intersight_organization_organization.my_org.id

data "intersight_organization_organization" "my_org" {
    name = "default"
}


# ===================== Define Local Variables  ==========================================
locals {

  org_moid = data.intersight_organization_organization.my_org.id  

}


# ===================== Define Input Variables  ==========================================
# Define Input Variables
# Usage from CLI:  terraform plan -var "apikey=<my-key>" -var "secretkey=<pem-key>"
# Variables can be set in TFCB "Variables" section of the Workspace
# Variables can be set with environment variables (MAC):  export TF_VAR_apikey=<my-api-key>

#         export TF_VAR_apikey=<my-api-key>
variable "apikey" {
  description = "API key ID for Intersight account"
  type = string
}

#         export TF_VAR_apikey=<my-secret-pem-key>
#   or    export TF_VAR_secretkey=`cat ~/Downloads/SecretKey.txt` 
variable "secretkey" {
  description = "secret key for Intersight API vsn 2"
  type = string
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
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/chassis_profile
# ** Set "action" and "control_action" parameters to "No-op"
# ** Set "error_state" parameter to ""
# ** Set the orgainization "moid" equal to your local organization variable (local.org_moid)





#<<<<<  Run Terraform init and Terraform plan when ready     >>>>>>
#<<<<<  If successful, run Terraform apply and enter yes     >>>>>>
#<<<<<  If successful, run Terraform apply a second time     >>>>>>
#<<<<<  Check your new creation using the Intersight GUI     >>>>>>