# =============================================================================
# Pod Server VSAN Policies
#  - Creates vNic vSAN Policies for use Pod-wide
#  - This must match up with domain fabric's (FI's) vSAN Policies
# -----------------------------------------------------------------------------


resource "intersight_vnic_fc_network_policy" "fc_vsan_100" {
  name                = "${local.pod_policy_prefix}-fc-vsan-100"
  description         = local.description
  vsan_settings {
    id          = 100
    object_type = "vnic.VsanSettings"
  }
  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }
}

resource "intersight_vnic_fc_network_policy" "fc_vsan_101" {
  name                = "${local.pod_policy_prefix}-fc-vsan-101"
  description         = local.description
  vsan_settings {
    id          = 101
    object_type = "vnic.VsanSettings"
  }
  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }
}


resource "intersight_vnic_fc_network_policy" "fc_vsan_200" {
  name                = "${local.pod_policy_prefix}-fc-vsan-200"
  description         = local.description
  vsan_settings {
    id          = 200
    object_type = "vnic.VsanSettings"
  }
  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }
}

resource "intersight_vnic_fc_network_policy" "fc_vsan_201" {
  name                = "${local.pod_policy_prefix}-fc-vsan-201"
  description         = local.description
  vsan_settings {
    id          = 201
    object_type = "vnic.VsanSettings"
  }
  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }
}
