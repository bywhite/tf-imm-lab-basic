# =============================================================================
#  Server Storage Related  Policies
#  - Storage Policy
#  - 
#  - 
# -----------------------------------------------------------------------------

# Comment-out storage policies to remove from policy & then remove from server template policy bucket
# Also set/remove from server-boot-order.tf

resource "intersight_storage_storage_policy" "server_storage_policy1" {
  name                     = "${var.server_policy_prefix}-storage-policy-1"
  description              = var.description
  m2_virtual_drive {
    enable      = true
    controller_slot = "MSTOR-RAID-1"
    object_type = "storage.M2VirtualDriveConfig"
  }
  use_jbod_for_vd_creation = false
  unused_disks_state       = "NoChange"
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
  
}

