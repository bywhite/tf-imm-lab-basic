# =============================================================================
# Variables 
# Variable values can be set or changed in many places
#   - Set from CLI:  terraform apply -var "api_key=<my-key>" -var "secretkey=<pem-key>"
#   - Variables can be set in TFCB "Variables" section of the Workspace
#   - Variables can be set with environment variables (MAC):  export TF_VAR_api_key=<my-api-key>
#   - Variables are often used within code blocks to set resource parameter values
#   - Variables are also used as Input Variables within submodules
# Note: Sensitive information should be passed into variables (var.<variable>) from an
#       external source such as from TFCB, CLI parameters or environment variables
#       Sensitive data values should never be stored within your code
#       Variables intended to store sensitive values should be defined with "sensitive = true"
# -----------------------------------------------------------------------------


#         export TF_VAR_api_key=<my-api-key>
variable "apikey" {
  description = "API key ID for Intersight account"
  type        = string
}

#         export TF_VAR_secretkey=`cat ~/Downloads/SecretKey.txt` 
variable "secretkey" {
  description = "secret key for Intersight API vsn 2"
  type        = string
  sensitive   = true
}

