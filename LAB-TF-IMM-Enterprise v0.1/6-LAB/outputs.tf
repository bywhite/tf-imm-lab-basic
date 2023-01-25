# ===================== Define Output Variables  =========================================


output "my_org" {
  value       = data.intersight_organization_organization.my_org.name
  description = "My Intersight Organization Name"
  sensitive   = false
}

# Substitute the IP Pool module provided moid: module.ip_pool1.ip_pool_chassis_moid
#  for the original resource call: intersight_ippool_pool.ippool_pool_chassis.moid
#  in the "value" assignment below.  Do the same for tne ".._name" output variable
output "ip_pool_chassis_moid" {
  description = "moid of the IP Pool for Chassis IMC Access Policy"
  value       = intersight_ippool_pool.ippool_pool_chassis.moid
}
output "ip_pool_chassis_name" {
  description = "moid of the IP Pool for Chassis IMC Access Policy"
  value       = intersight_ippool_pool.ippool_pool_chassis.name
}
