# Variables are used to increase code re-use and improve security of sensitive data through abstraction

# Sensitive information should be stored in variables (var.<variable>) to be passed in from external sources
#    Terraform Variables can be passed in from TFCB, CLI apply parameters and environment variables (TF_VAR_<var-name>)

#  The following should be Set in environment variables TF_VAR_<variable-name>
#    apikey  (ID for Intersight)         with Mac:   export TF_VAR_apikey="<your_intersight_api_key>"
#    secretkey can use the default which specifies the location of the file, alternatively set an environment variable:
#    secretkey (Key for Intersight)      with Mac:   export TF_VAR_secretkey=`cat ~/Downloads/SecretKey.txt`    # use back-tic's (not quote)



# https://intersight.com/an/settings/api-keys/
## Generate API key to obtain the API key and secret key
variable "apikey" {
    description = "API key for Intersight account"
    type = string
}

variable "secretkey" {
  description = "secret key for Intersight API vsn 2"
  type        = string
  sensitive   = true
}

# This is the Intersight URL (could be URL to Intersight Private Virtual Appliance instead)
variable "endpoint" {
    description = "Intersight API endpoint"
    type = string
    default = "https://intersight.com"
}

# This is the target organization defined in Intersight to be configured
variable "organization" {
    type = string
    default = "demo-tf"
}

variable "imc_admin_password" {
    type = string
    default = "Cisco123"
}
variable "snmp_password" {
    type = string
    default = "Cisco123"
}
