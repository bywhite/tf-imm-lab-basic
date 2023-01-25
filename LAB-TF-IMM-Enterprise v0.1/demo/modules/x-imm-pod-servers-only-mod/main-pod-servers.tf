# # =============================================================================
# # Main.tf defines Server Profiles - without a template
# # Builds: Server Profiles and associated Server Resource Pool
# # Creates: Server Profiles by "Count" ("Resource Pool" not enabled yet)
# # This is not the recommended method - Template based is preferred
# -----------------------------------------------------------------------------



# =============================================================================
# Server Profiles Only - No Template
# -----------------------------------------------------------------------------

resource "intersight_server_profile" "server_list" {
    # Will add Count to create multiple instances and use index to change server names
  count = var.server_count

  name              = "${var.server_policy_prefix}-server-${count.index + 1}"
  description     = var.description

  type = "instance"
  # action          = "No-op"
  target_platform = "FIAttached"
  uuid_address_type = "POOL"

  uuid_pool {
      moid        = var.server_uuid_pool_moid
      object_type = "uuidpool.Pool"
    }

  server_assignment_mode = "None"                 #options: "POOL" "Static" "None"
#  
#   dynamic "associated_server_pool" {    # Also server_pool object available
#     for_each = var.associated_server_pool
#     content {
#       moid        = assigned_server.value.moid
#       object_type = "resourcepool.Pool"
#     }
#   }

#   dynamic "assigned_server" {
#     for_each = var.assigned_server
#     content {
#       moid        = assigned_server.value.moid
#       object_type = assigned_server.value.object_type
#     }
#   }


  # the following policy_bucket statements map policies to this profile
  
  # No local storage used for this VMware AutoDeploy configuration
  # policy_bucket {
  #   moid = intersight_storage_storage_policy.server_storage_policy1.moid
  #   object_type = "storage.StoragePolicy"
  # }

  #   policy_bucket { # Certificate Management
  #     moid        = ""
  #     object_type = ""
  #   }
  
  policy_bucket {
    moid = intersight_bios_policy.bios_default_policy.moid
    object_type = "bios.Policy"
  }
  policy_bucket {
    moid        = intersight_boot_precision_policy.boot_precision_1.moid
    object_type = "boot.PrecisionPolicy"
  }
 policy_bucket {
   moid = intersight_ipmioverlan_policy.ipmi1.moid
   object_type = "ipmioverlan.Policy"
 }
  policy_bucket {
    moid = intersight_kvm_policy.kvmpolicy_1.moid
    object_type = "kvm.Policy"
  }
  # IMC User Policy
  policy_bucket {
    moid = var.user_policy_moid
    object_type = "iam.EndPointUserPolicy"
  }
  # IMC User Policy  
  # policy_bucket {
  #   moid = intersight_iam_end_point_user_policy.user_policy_1.moid
  #   object_type = "iam.EndPointUserPolicy"
  # }
  policy_bucket {
    moid = intersight_vmedia_policy.vmedia_1.moid
    object_type = "vmedia.Policy"
  }
  policy_bucket {
    moid = intersight_power_policy.server_power_x.moid
    object_type = "power.Policy"
  }
  policy_bucket {
    moid = intersight_access_policy.access_1.moid
    object_type = "access.Policy"
  }
  policy_bucket {
    moid = intersight_snmp_policy.server_snmp.moid
    object_type = "snmp.Policy"
  }
  policy_bucket {
    moid = intersight_syslog_policy.syslog_policy.moid
    object_type = "syslog.Policy"
  }
 policy_bucket {
   moid = intersight_sol_policy.sol1.moid
   object_type = "sol.Policy"
 }
  policy_bucket {
    moid = intersight_vnic_lan_connectivity_policy.vnic_lan_1.moid
    object_type = "vnic.LanConnectivityPolicy"
  }
  policy_bucket {
    moid        = intersight_vnic_san_connectivity_policy.vnic_san_con_1.moid
    object_type = "vnic.SanConnectivityPolicy"
  }

  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }

  depends_on = [
    intersight_vmedia_policy.vmedia_1, intersight_power_policy.server_power_x, intersight_snmp_policy.server_snmp,
    intersight_syslog_policy.syslog_policy, # intersight_iam_end_point_user_policy.user_policy_1,
    intersight_bios_policy.bios_default_policy, intersight_vnic_san_connectivity_policy.vnic_san_con_1
    # intersight_storage_storage_policy.server_storage_policy1,
  ]
}
