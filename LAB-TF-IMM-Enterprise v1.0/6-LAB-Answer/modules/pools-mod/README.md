Reference: https://developer.hashicorp.com/terraform/tutorials/modules/module-create

Module best practices (per Hashi, see above)
Modules should contain the following files at a minimum:
    LICENSE       # https://developer.hashicorp.com/terraform/tutorials/modules/module-create#license
    README.md     # https://developer.hashicorp.com/terraform/tutorials/modules/module-create#readme-md
    main.tf       # https://developer.hashicorp.com/terraform/tutorials/modules/module-create#main-tf
    variables.tf  # https://developer.hashicorp.com/terraform/tutorials/modules/module-create#variables-tf
    outputs.tf    # https://developer.hashicorp.com/terraform/tutorials/modules/module-create#outputs-tf


The purpose of this module is to create an Intersight IP Pool for use by an IMC Access Policy for a Chassis.

USAGE: 
    module "ip_pool1" {
        source = "./modules/pools-mod"

        organization = local.org_moid
        apikey       = var.apikey
        secretkey    = var.secretkey
    }


Inputs:
    organization - Intersight moid of target Organization
    apikey       - Intersight API ID (version 2)
    secretkey    - Intersight Secret Key for API ID

Outputs: 
    ip_pool_chassis_moid - Intersight moid of the created IP Pool
    ip_pool_chassis_name - Intersight Name of the created IP Pool
    