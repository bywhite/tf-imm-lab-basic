
locals {

  # Create a list of chassis indexes Example of five chassis: [1,2,3,4,5]
  chassis_index_numbers  = range(1,var.chassis_9508_count + 1)
  # Since we start at 1 instead of 0, we must add 1 to the total count

  # Convert the list of numbers to a set of strings
  chassis_index_set     = toset([for v in local.chassis_index_numbers : tostring(v)])


  # Create a list of Chassis Profile moids
  chassis_profile_moids = values(intersight_chassis_profile.chassis_9508_profile)[*].id

  # Create a list of Chassis Profile names
  chassis_profile_names = values(intersight_chassis_profile.chassis_9508_profile)[*].name


  # var.switch_vlans_6536      # Example: "2-100,105,110,115 >> {"vlan-2": 2, "vlan-3": 3, etc}"
  vlan_split = length(regexall("-", var.switch_vlans_6536)) > 0 ? tolist(
    split(",", var.switch_vlans_6536)
  ) : tolist(var.switch_vlans_6536)
  vlan_lists = [for s in local.vlan_split : length(regexall("-", s)) > 0 ? [
    for v in range(
      tonumber(element(split("-", s), 0)),
      (tonumber(element(split("-", s), 1)
    ) + 1)) : tonumber(v)] : [s]
  ]
  flattened_vlan_list = flatten(local.vlan_lists)
  vlan_list_set       = toset(local.flattened_vlan_list)

}
