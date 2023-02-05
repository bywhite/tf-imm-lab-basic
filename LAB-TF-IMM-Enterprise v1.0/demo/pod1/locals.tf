#__________________________________________________________
#
# Local Variables Section
#__________________________________________________________

locals {

#  The following are defined as "local" variables (local.<variable>)
# Local variables are typically used for data transformation or to set initial values
# Sensitive information should be stored in variables (var.<variable>) to be passed in
#    var.<variables can be passed in from TFCB, CLI apply parameters and environment variables

  # Intersight Organization Variable
  org_moid = data.intersight_organization_organization.my_org.id

  secretkey = file("../../SecretKey.txt")
  
  pod_policy_prefix = "demo-tf"                           # <-- change when copying
  
  pod_id = "FF"                                                # <-- change when copying
#           0 is for OFL    RCO is 1     BUF is 3  other locations TBD
#           1 is for first pod  2 is for second pod,  3 is for third pod    etc. 
#  Example RCO Pod 2 ID would be:  "12"
#  All Identity Pools for a Pod will contain the POD ID (MAc, WWNN, WWPN, UUID)

  description = "Built by Terraform ${local.pod_policy_prefix}"

  #Every object created in the pod main module will have these tags
  pod_tags = [
    { "key" : "environment", "value" : "dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "pod", "value" : "${local.pod_policy_prefix}" }
  ]

# VNIC QoS policy moids Pod-Wide
  vnic_qos_besteffort = module.imm_pod_qos_mod.vnic_qos_besteffort_moid
  vnic_qos_bronze     = module.imm_pod_qos_mod.vnic_qos_bronze_moid
  vnic_qos_silver     = module.imm_pod_qos_mod.vnic_qos_silver_moid
  vnic_qos_gold       = module.imm_pod_qos_mod.vnic_qos_gold_moid
  # vnic_qos_platinum = module.imm_pod_qos_mod.vnic_qos_platinum_moid
  vnic_qos_fc_moid    = module.imm_pod_qos_mod.vnic_qos_fc_moid
  
}