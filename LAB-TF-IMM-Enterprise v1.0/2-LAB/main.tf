# ==========================================================================================
# The purpose of this lab is to create policies for the chassis profile
# 
# ------------------------------------------------------------------------------------------
# IMM Code Examples Can Be Found at:
# https://github.com/jerewill-cisco?tab=repositories
# https://github.com/bywhite/tf-imm-pod-example-code
# https://github.com/terraform-cisco-modules/terraform-intersight-imm/tree/master/modules
# https://github.com/scotttyso/terraform-intersight-easy-imm
# ------------------------------------------------------------------------------------------


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
  apikey    = var.apikey
  secretkey = var.secretkey
  endpoint  = "https://intersight.com"
}

data "intersight_organization_organization" "my_org" {
    name = "demo-tf"
  
}


# ===================== Define Local Variables  ==========================================
locals {

  org_moid = data.intersight_organization_organization.my_org.id
  # secretkey = file("../SecretKey.txt")

}


# ===================== Define Input Variables  ==========================================
variable "apikey" {
  description = "API key ID for Intersight account"
  type        = string
}


# ===================== Define Output Variables  =========================================
output "my_org" {
  value       = data.intersight_organization_organization.my_org.name
  description = "My Intersight Organization Name"
  sensitive   = false
}


# ===================== Start Code Resource Section  =====================================


# =============================================================================
# Chassis Profile
# -----------------------------------------------------------------------------
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/chassis_profile

resource "intersight_chassis_profile" "chassis_9508_profile" {
  name            = "chassis_profile1"
  description     = "chassis profile"
  type            = "instance"
  target_platform = "FIAttached"
  action          = "No-op"
  config_context {
    object_type    = "policy.ConfigContext"
    control_action = "No-op"
    error_state    = ""
  }
  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }
}

# ****************************************************************************
# ========!=================!====================!==================!=========
# ================!=================!====================!====================
# ========!=================!====================!==================!=========
# * * * * * * * * *       BEGIN  LAB 2  SECTION              * * * * * * * * *




# =============================================================================
# Chassis Power Policy
# -----------------------------------------------------------------------------
# Create a Power Policy
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/power_policy
#   Reference: https://github.com/jerewill-cisco/intersight-terraform-simplified/blob/main/policy_power.tf
# ** Set policy alias (resource's instance name) to "chassis_9508_power"
# ** Set "power_profiling" parameter to "Enabled"
# ** Set "power_restore_state" parameter to "LastState"
# ** Set "redundancy_mode" parameter to "Grid"
# ** Set the orgainization "moid" equal to your local organization variable (local.org_moid)




# =============================================================================
# Thermal Policy
# -----------------------------------------------------------------------------
# Create a Thermal Policy
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/thermal_policy
#   Reference: https://github.com/jerewill-cisco/intersight-terraform-simplified/blob/main/policy_thermal.tf
# ** Just create a single policy
# ** Set policy alias (resource's instance name) to "chassis_9508_thermal"
# ** Set "name" parameter to "thermal-balanced"
# ** Set "fan_control_mode" parameter to "Balanced"
# ** Set the orgainization "moid" equal to your local organization variable (local.org_moid)




# =============================================================================
# SNMP Policy
# -----------------------------------------------------------------------------
# Create a SNMP Policy
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/thermal_policy
#   Reference: https://github.com/jerewill-cisco/intersight-terraform-simplified/blob/main/policy_thermal.tf
# ** Set policy alias (resource's var name) to "snmp1"
# ** Set the orgainization "moid" equal to your local organization variable (local.org_moid)
# ** Set "auth_password" parameter to "Cisco123"
# ** Set "privacy_password" parameter to "Cisco123"
# ** For now, make sure "profiles" block of code is "#" commented out (if it exists in your code)
# ensure you do not  have any "var" variables defined yet



# ========!=================!====================!==================!=========
# ================!=================!====================!=====================
# ========!=================!====================!==================!=========
# *  *  Before Proceeding to next mdoule, test your code     *    * 

#<<<<<  Run Terraform init and Terraform plan when ready     >>>>>>
#<<<<<  If successful, run Terraform apply and enter yes     >>>>>>
#<<<<<  If successful, run Terraform apply a second time     >>>>>>
#<<<<<  Check your new creation using the Intersight GUI     >>>>>>

#<<<<<  Run       Terraform destroy      * when instructed   >>>>>>
# Run: terraform destroy
#          when prompted enter: yes
