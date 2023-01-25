
# ===================== Define Input Variables  ==========================================
# Define Input Variables
# Usage from CLI:  terraform plan -var "api_key=<my-key>" -var "secretkey=<pem-key>"
# Variables can be set in TFCB "Variables" section of the Workspace
# Variables can be set with environment variables (MAC):  export TF_VAR_api_key=<my-api-key>

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

