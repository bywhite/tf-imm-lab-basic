# =============================================================================
#  Pools to support Policies
#    - IP Pool for Chassis IMC Access Policy
# -----------------------------------------------------------------------------


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
    moid        = local.org_moid
  }

}

