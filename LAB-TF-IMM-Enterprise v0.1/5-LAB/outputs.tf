# ===================== Define Output Variables  =========================================


output "my_org" {
  value       = data.intersight_organization_organization.my_org.name
  description = "My Intersight Organization Name"
  sensitive   = false
}

output "ip_pool_chassis_moid" {
  description = "moid of the IP Pool for Chassis IMC Access Policy"
  value       = intersight_ippool_pool.ippool_pool_chassis.moid
}
output "ip_pool_chassis_name" {
  description = "moid of the IP Pool for Chassis IMC Access Policy"
  value       = intersight_ippool_pool.ippool_pool_chassis.name
}

output "chassis_index_set" {
  description  = "The list of index numbers as strings in a set"
  value        = local.chassis_index_set
}