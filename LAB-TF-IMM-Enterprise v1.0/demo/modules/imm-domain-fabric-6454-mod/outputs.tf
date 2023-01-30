#__________________________________________________________
#
# 6454 Domain and 9508 Chassis Outputs
#__________________________________________________________


output "fi6454_cluster_domain_name" {
  description = "name of domain cluster profile created"
  value       = intersight_fabric_switch_cluster_profile.fi6454_cluster_profile.name
}

output "fi6454_cluster_profile_name" {
  description = "name of domain cluster profile created"
  value       = intersight_fabric_switch_cluster_profile.fi6454_cluster_profile.name
}

output "fi6454_cluster_profile_moid" {
  description = "moid of domain cluster profile created"
  value       = intersight_fabric_switch_cluster_profile.fi6454_cluster_profile.moid
}

output "chassis_9508_profile_moids" {
  description = "chassis cluster profiles created"
  value       = local.chassis_profile_moids
}

output "chassis_9508_profile_names" {
  description = "chassis cluster profiles created"
  value       = local.chassis_profile_names
}

output "chassis_count" {
  description = "how many chassis profiles were created"
  value       = var.chassis_9508_count
}

output "chassis_index" {
  description = "array or list of indexes of chassis"
  value       = local.chassis_index_set
}

output "fabric_vlan_list_moid" {
  description = "Fabric VLAN moid for fabric Name:IP pairs"
  value       = { for v in sort(keys(intersight_fabric_vlan.fabric_vlans)) : v => intersight_fabric_vlan.fabric_vlans[v].moid }
}