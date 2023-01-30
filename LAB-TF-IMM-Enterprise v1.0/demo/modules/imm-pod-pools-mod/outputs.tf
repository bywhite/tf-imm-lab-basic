# =============================================================================
# Pool Outputs for Pod-wide usage
#______________________________________________________________________________

output "ip_pool_moid" {
  description = "moid of the Server IP Pool."
  value = intersight_ippool_pool.ippool_pool.moid
}
output "ip_pool_name" {
  description = "moid of the Server IP Pool."
  value = intersight_ippool_pool.ippool_pool.name
}

output "ip_pool_chassis_moid" {
  description = "moid of the IP Pool for Chassis IMC Access Policy"
  value       = intersight_ippool_pool.ippool_pool_chassis.moid
}
output "ip_pool_chassis_name" {
  description = "moid of the IP Pool for Chassis IMC Access Policy"
  value       = intersight_ippool_pool.ippool_pool_chassis.name
}

output "mac_pool_moid" {
  description = "moid of the MAC Pool."
  value = intersight_macpool_pool.macpool_pool1.moid
}
output "mac_pool_name" {
  description = "moid of the MAC Pool."
  value = intersight_macpool_pool.macpool_pool1.name
}

output "wwnn_pool_moid" {
  description = "moid of the WWNN Pool"
  value = intersight_fcpool_pool.wwnnpool_pool1.moid
}
output "wwnn_pool_name" {
  description = "moid of the WWNN Pool"
  value = intersight_fcpool_pool.wwnnpool_pool1.name
}

output "wwpn_pool_a_moid" {
  description = "moid of the WWWPN-A pool"
  value = intersight_fcpool_pool.wwpnpool_poolA.moid
}
output "wwpn_pool_a_name" {
  description = "moid of the WWWPN-A pool"
  value = intersight_fcpool_pool.wwpnpool_poolA.name
}

output "wwpn_pool_b_moid" {
  description = "moid of the WWWPN-B pool"
  value = intersight_fcpool_pool.wwpnpool_poolB.moid
}
output "wwpn_pool_b_name" {
  description = "moid of the WWWPN-B pool"
  value = intersight_fcpool_pool.wwpnpool_poolB.name
}

output "uuid_pool_moid" {
  description = "moid of the UUID pool"
  value = intersight_uuidpool_pool.uuidpool_pool1.moid
}
output "uuid_pool_name" {
  description = "moid of the UUID pool"
  value = intersight_uuidpool_pool.uuidpool_pool1.name
}
