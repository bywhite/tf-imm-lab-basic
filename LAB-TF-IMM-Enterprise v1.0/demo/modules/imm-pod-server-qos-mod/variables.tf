# =============================================================================
# Module input parameters to create Pod-wide QoS policies
# -----------------------------------------------------------------------------

# =============================================================================
# Intersight IMM Org to create policies in
# -----------------------------------------------------------------------------

variable "org_id" {
  type        = string
  description = "moid for organization in which to create the policies"
}

# =============================================================================
# Naming Standards
# -----------------------------------------------------------------------------

variable "policy_prefix" {
  type        = string
  description = "prefix for all policies created"
  default     = "tf"
}

variable "description" {
  type        = string
  description = "description field for all policies"
  default     = ""
}

variable "tags" {
  type        = list(map(string))
  description = "user tags to be applied to all policies"
  default     = []
}