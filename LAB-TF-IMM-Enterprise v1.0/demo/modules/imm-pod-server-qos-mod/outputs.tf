# =============================================================================
#  QoS Related Outputs
#  Due to Policy Bucket constraints, Switch CoS is created with Switch Policies
#  QoS policy settings must match Switch and Network QoS/CoS settigns
# -----------------------------------------------------------------------------

# Eth QoS Policies
output "vnic_qos_besteffort_moid" {
  description = "Best Effort QoS moid"
  value = intersight_vnic_eth_qos_policy.vnic_qos_besteffort.moid
}
output "vnic_qos_bronze_moid" {
  description = "Bronze QoS moid"
  value = intersight_vnic_eth_qos_policy.vnic_qos_bronze.moid
}
output "vnic_qos_silver_moid" {
  description = "Silver Qos moid"
  value = intersight_vnic_eth_qos_policy.vnic_qos_silver.moid

}
output "vnic_qos_gold_moid" {
  description = "Gold Qos moid"
  value = intersight_vnic_eth_qos_policy.vnic_qos_gold.moid
}
# output "vnic_qos_platinum_moid" {
#   description = "Platinum Qos moid"
#   value = intersight_vnic_eth_qos_policy.vnic_qos_platinum.moid
# }

# Fibre Channel FC QoS (CoS 3) Policy
output "vnic_qos_fc_moid" {
  description = "Fiber Channel (FC) Qos moid"
  value = intersight_vnic_fc_qos_policy.vnic_qos_fc.moid
}

