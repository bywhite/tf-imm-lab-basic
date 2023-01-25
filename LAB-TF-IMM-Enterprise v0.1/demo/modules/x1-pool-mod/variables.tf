variable "organization" {
  type        = string
  description = "moid for organization in which to create the policies"
}

variable "pod_id" {
    type  = string
    description = "Starting MAC Address of Block of 1000 for MAC Pool"
    default     = "00"
}
