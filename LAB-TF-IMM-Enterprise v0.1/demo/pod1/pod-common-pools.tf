# Create a sequential IP pool for IMC access. Change the from and size to what you would like
# Mac tip: Use CMD+K +C to comment out blocks.   CMD+K +U will un-comment blocks of code

module "imm_pool_mod" {
  source = "../modules/imm-pod-pools-mod"
  
  # external sources
  organization    = local.org_moid

  # every policy created will have this prefix in its name
  policy_prefix = local.pod_policy_prefix
  description   = local.description

  ip_size     = "500"
  ip_start = "10.10.10.10"
  ip_gateway  = "10.10.10.1"
  ip_netmask  = "255.255.254.0"
  ip_primary_dns = "8.8.8.8"

  chassis_ip_size     = "150"
  chassis_ip_start = "10.10.2.11"
  chassis_ip_gateway  = "10.10.2.1"
  chassis_ip_netmask  = "255.255.255.0"
  chassis_ip_primary_dns = "8.8.8.8"

  pod_id = local.pod_id
  # used to create moids for Pools: MAC, WWNN, WWPN

  tags = [
    { "key" : "Environment", "value" : "dev" },
    { "key" : "Orchestrator", "value" : "Terraform" },
    { "key" : "pod", "value" : "ofl-dev-pod1" }
  ]
}


