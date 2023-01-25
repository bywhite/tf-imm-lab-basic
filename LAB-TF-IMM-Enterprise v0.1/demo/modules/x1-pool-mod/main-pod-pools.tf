resource "intersight_macpool_pool" "cisco_af_1" {
  name = "cisco_af_1"

  mac_blocks {
    from = "00:25:B5:${var.pod_id}:00:01"
    size = 1000
  }
  organization {
    object_type = "organization.Organization"
    moid = var.organization 
  }
}
