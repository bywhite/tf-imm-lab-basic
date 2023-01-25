variable "organization" {
  type = string
  description = "moid for Intersight Org to create pools in"
}

variable "apikey" {
  type = string
  description = "apikey passed from parent module"
}

variable "secretkey" {
  type = string
  description = "secretkey passed from parent module"
}
