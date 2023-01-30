# Output as needed to reveal Objects created

output "intersight_organization_name" {
  value         = var.organization
  description   = "Default is default, otherwise set in TFCB Variable"
}

output "interisight_org_ofl_dev_moid" {
    value       = local.org_moid
    description = "Organization in Intersight for Pod objects"
}

output "pod_id" {
    value       = local.pod_id
    description = "Pod ID is used in all identifiers: MAC, WWNN, WWPN, UUID"
}

output "domain_vmw_1_name" {
    value       = module.intersight_policy_bundle_vmw_1.fi6536_cluster_domain_name
    description = "IMM Domain Cluster VMW-1 TF object name"
}

# output "vmw_1_chassis_count" {
#     value       = module.intersight_policy_bundle_vmw_1.chassis_count
#     description = "How many chassis were made by module"
# }

# output "vmw_1_chassis_index" {
#     value       = module.intersight_policy_bundle_vmw_1.chassis_index
#     description = "How many chassis were made by module"
# }


output "domain_vmw_1_profile_name" {
    value       = module.intersight_policy_bundle_vmw_1.fi6536_cluster_profile_name
    description = "IMM Domain Cluster VMW-1 TF object name"
}

output "domain_vmw_1_moid" {
    value       = module.intersight_policy_bundle_vmw_1.fi6536_cluster_profile_moid
    description = "IMM Domain Cluster VMW-1 moid"
}

# output "vmw_1_chassis_9508_profile_moids" {
#     value       = module.intersight_policy_bundle_vmw_1.chassis_9508_profile_moids
#     description = "Chassis moids for cluster"
# }

# output "vmw_1_chassis_9508_profile_names" {
#     value       = module.intersight_policy_bundle_vmw_1.chassis_9508_profile_names
#     description = "Chassis moids for cluster"
# }
# output "fabric_vlan_pairslist_moid" {
#     value       = module.intersight_policy_bundle_vmw_1.fabric_vlan_list_moid
#     description = "Moid for fabric_vlan pairs-list of VLAN-Name: VLAN-ID"
# }


output "ofl_dev_pod1_ip_pool_chassis_moid" {
    value       = module.imm_pool_mod.ip_pool_chassis_moid
    description = "IP_Pool moid for chassis in-band IP's"
}

output "ofl_dev_pod1_ip_pool_server_moid" {
    value       = module.imm_pool_mod.ip_pool_moid
    description = "IP_Pool moid for servers in Pod"
}
output "ofl_dev_pod1_ip_pool_server_name" {
    value       = module.imm_pool_mod.ip_pool_name
    description = "IP_Pool name for servers in Pod"
}

output "ofl_dev_pod1_mac_pool_moid" {
    value       = module.imm_pool_mod.mac_pool_moid
    description = "MAC Pool moid for cluster"
}

output "ofl_dev_pod1_wwnn_pool_moid" {
    value       = module.imm_pool_mod.wwnn_pool_moid
    description = "WWNN pool moid for cluster"
}

output "ofl_dev_pod1_wwpn_pool_a_moid" {
    value       = module.imm_pool_mod.wwpn_pool_a_moid
    description = "WWPN Pool moid for A Fabric"
}

output "ofl_dev_pod1_wwpn_pool_b_moid" {
    value       = module.imm_pool_mod.wwpn_pool_b_moid
    description = "WWPN Pool moid for B Fabric"
}

output "ofl_dev_pod1_uuid_pool_moid" {
    value       = module.imm_pool_mod.uuid_pool_moid
    description = "UUID Pool moid for cluster"
}

# output "server_profile_template_vmw_1_moid" {
#     value       = module.server_template_sorta1.server_profile_template_moid
# }
# output "server_profile_template_vmw_1_name" {
#     value       = module.server_template_sorta1.server_profile_template_name
# }

# output "server_profile_template_vmw_1_interfaces" {
#     value       = module.imm_pod_server_vmw_1.server_interfaces
#     description = "List of server template interfaces"
# }

# output "z-server_profile_names" {
#   value       = module.server_template_sorta1.server_profile_names
#   description = "List of sorta1 template server names"
# }
