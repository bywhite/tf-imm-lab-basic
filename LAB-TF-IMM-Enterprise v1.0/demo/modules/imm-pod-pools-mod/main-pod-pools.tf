# This file creates the following pools:
#    - IP pool for IMC Access
#    - MAC pool for vNICs
#    - WWNN, WWPN-A and WWPN-B FC pools
# =============================================================================
#  Pod Related Pools
#  - IP Pool for Server IMC
#  - IP Pool for Chassis IMC
#  - MAC Pool
#  - WWNN Pool
#  - WWPN-A Pool
#  - WWPN-B Pool
#  - UUID Pool
# -----------------------------------------------------------------------------


# =============================================================================
# IP Pool for Server IMC
# -----------------------------------------------------------------------------
# Create a sequential IP pool for IMC access.
resource "intersight_ippool_pool" "ippool_pool" {
  # moid read by: = intersight_ippool_pool.ippool_pool.moid
  name = "${var.policy_prefix}-pool-ip-imc-1"
  description = var.description
  assignment_order = "sequential"

  ip_v4_blocks {
    
    from  = var.ip_start
    #from = "1.1.1.11"

    size  = var.ip_size
    #size = "200"
  }
  # dynamic ip_v4_blocks {
  #   for_each = formatlist("%X", range(0,4))
  #   content {
  #     from = "10.10.${ip_v4_blocks.value}.11"
  #     size          = "240"
  #   } 
  # }
  ip_v4_config {
    object_type = "ippool.IpV4Config"
    
    gateway        = var.ip_gateway
    #gateway       = "10.10.10.1"
    
    netmask        = var.ip_netmask
    #netmask       = "255.255.255.0"
    
    primary_dns    = var.ip_primary_dns
    #primary_dns   = "8.8.8.8"
    
    }

  organization {
      object_type = "organization.Organization"
      moid = var.organization
      }
}

# Create a sequential IP pool for IMC access.

resource "intersight_ippool_pool" "ippool_pool_chassis" {
  # moid read by: = intersight_ippool_pool.ippool_pool.moid
  name = "${var.policy_prefix}-pool-ip-chassis-imc-1"
  description = var.description
  assignment_order = "sequential"

  ip_v4_blocks {
    
    from  = var.chassis_ip_start
    #from = "10.10.2.11"

    size  = var.chassis_ip_size
    #size = "150"
  }

  ip_v4_config {
    object_type = "ippool.IpV4Config"
    
    gateway        = var.chassis_ip_gateway
    #gateway       = "10.10.2.1"
    
    netmask        = var.chassis_ip_netmask
    #netmask       = "255.255.255.0"
    
    primary_dns    = var.chassis_ip_primary_dns
    #primary_dns   = "8.8.8.8"
    
    }

  organization {
      object_type = "organization.Organization"
      moid = var.organization
      }
}


resource "intersight_macpool_pool" "macpool_pool1" {
  name = "${var.policy_prefix}-pool-mac-1"
  description = var.description
  assignment_order = "sequential"
  dynamic mac_blocks {
    for_each = formatlist("%X", range(0,10))
    content {
      from = "00:25:B5:${var.pod_id}:${mac_blocks.value}0:01"
      size          = "1000"
    } 
  }
  organization {
    object_type = "organization.Organization"
    moid = var.organization 
    }
}


resource "intersight_fcpool_pool" "wwnnpool_pool1" {
  name = "${var.policy_prefix}-pool-wwnn-1"
  description = var.description
  assignment_order = "sequential"
  pool_purpose = "WWNN"
  dynamic id_blocks {
    for_each = formatlist("%X", range(0,10))
    content {
      from  = "20:00:25:B5:${var.pod_id}:${id_blocks.value}0:00:01"
      #from        = "20:00:25:B5:FE:10:00:01"
      size        =  1000
    }  
  }
  organization {
    object_type = "organization.Organization"
    moid = var.organization 
    }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_fcpool_pool" "wwpnpool_poolA" {
  name = "${var.policy_prefix}-pool-wwpn-a-1"
  description = var.description
  assignment_order = "sequential"
  pool_purpose = "WWPN"
  dynamic id_blocks {
    for_each = formatlist("%X", range(0,10))
    content {
      from  = "20:00:25:B5:${var.pod_id}:${id_blocks.value}A:00:01"
      #from        = "20:00:25:B5:FE:1A:00:01"
      size        =  1000
    }  
  }
  organization {
    object_type = "organization.Organization"
    moid = var.organization 
    }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_fcpool_pool" "wwpnpool_poolB" {
  name = "${var.policy_prefix}-pool-wwpn-b-1"
  description = var.description
  assignment_order = "sequential"
  pool_purpose = "WWPN"
  dynamic id_blocks {
    for_each = formatlist("%X", range(0,10))
    content {
      from  = "20:00:25:B5:${var.pod_id}:${id_blocks.value}B:00:01"
      #from        = "20:00:25:B5:FE:1B:00:01"
      size        =  1000
    }  
  }
  organization {
    object_type = "organization.Organization"
    moid = var.organization 
    }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
 

resource "intersight_uuidpool_pool" "uuidpool_pool1" {
  name             = "${var.policy_prefix}-pool-uuid-1"
  description      = var.description
  assignment_order = "sequential"
  prefix           = "1728E8C7-7B40-47E9"
  dynamic uuid_suffix_blocks {
    for_each = formatlist("%X", range(0,2))
    content {
      from  = "${var.pod_id}0${uuid_suffix_blocks.value}-000000000000"
      #from        = "xx0y-zzzzzzzzzzzz"
      size        =  1000
    }  
  }
  organization {
    object_type = "organization.Organization"
    moid = var.organization 
    }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
 