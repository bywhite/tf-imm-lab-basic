# =============================================================================
# Pod FI and Server Related QoS Policies
#  - Creates vNic QoS Policies for each class of service
#  - This must match up with domain fabric's System QoS Policy
# -----------------------------------------------------------------------------

# # Due to policy bucket limitations, the default System QoS policy must be created with Switch Profile's moids attached.
# # Accordingly, the resource "intersight_fabric_system_qos_policy" is created with the domain fabric module instead of this module.


module "imm_pod_qos_mod" {       
  source = "../modules/imm-pod-server-qos-mod"

# =============================================================================
# Org external references
# -----------------------------------------------------------------------------

  org_id = local.org_moid

# =============================================================================
# Naming and tagging
# -----------------------------------------------------------------------------

  # Every QoS policy created will have this prefix in its name
  policy_prefix = local.pod_policy_prefix

  # This is the default description for IMM objects created
  description   = "built by Terraform for ${local.pod_policy_prefix}"

  #Every object created in the domain will have these tags
  tags = local.pod_tags

}
