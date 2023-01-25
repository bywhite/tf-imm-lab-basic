# ===================== Define Pools  =========================================

# Create an IP Pool
#   Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/ippool_pool
#   Reference: https://github.com/jerewill-cisco/intersight-terraform-simplified/blob/main/pools_ip.tf
# ** Set policy alias (resource's var name) to "ippool_pool_chassis"
# ** Configure with ip_v4_config 
# ** Set "name" parameter to "pool-ip-chassis-imc"
# ** Set "gateway" parameter to "10.10.10.1"
# ** Set "netmask" parameter to "255.255.255.0"
# ** Add an IP v4 block
        # ip_v4_blocks {
        #   from = "10.10.10.10"
        #   size = "240"
        # }
# ** Set the orgainization "moid" equal to your local organization variable (local.org_moid)
# After you create the IP Pool Resource, set the above chassis_imc_access resource inband_ip_pool moid

resource "intersight_ippool_pool" "ippool_pool_chassis" {
  name             = "pool-ip-chassis-imc"
  description      = "ippool pool for Chassis IMC access"
  assignment_order = "sequential"
  ip_v4_config {
    object_type = "ippool.IpV4Config"
    gateway     = "10.10.10.1"
    netmask     = "255.255.255.0"
    primary_dns = "8.8.8.8"
  }

    ip_v4_blocks {
      from = "10.10.10.10"
      size = "240"
  }

  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }

}
