resource "intersight_macpool_pool" "cisco_af_2" {
  name = "cisco_af_2"

  mac_blocks {
    from = "00:25:B5:AF:10:00"
    size = 1000
  }

  organization {
    object_type = "organization.Organization"
    moid = data.intersight_organization_organization.my_org.id
  }
}
