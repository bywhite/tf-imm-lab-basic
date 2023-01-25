# =============================================================================
#  FI Switch Profiles
#  - FI-A Switch Profile
#  - FI-B Switch Profile
#  Each profile associates itself with Cluster Profile
# -----------------------------------------------------------------------------

# =============================================================================
# 6454 Cluster (Domain) Switch Profiles
# -----------------------------------------------------------------------------

### NEW #### 6454 Switch Profile A ####
resource "intersight_fabric_switch_profile" "fi6454_switch_profile_a" {
  action      = "No-op"
  description = var.description
  name        = "${var.policy_prefix}-switch-a"
  type        = "instance"
  switch_cluster_profile {
    moid = intersight_fabric_switch_cluster_profile.fi6454_cluster_profile.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

### NEW #### 6454 Switch Profile B ####
resource "intersight_fabric_switch_profile" "fi6454_switch_profile_b" {
  action      = "No-op"
  description = var.description
  name        = "${var.policy_prefix}-switch-b"
  type        = "instance"
  switch_cluster_profile {
    moid = intersight_fabric_switch_cluster_profile.fi6454_cluster_profile.moid
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


# =============================================================================
# END of 6454 FI Cluster (Domain) and Switch Profiles
# -----------------------------------------------------------------------------
