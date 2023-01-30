
locals {

  # Create a list of chassis indexes Example of five chassis: [0,1,2,3,4]
  chassis_index_numbers  = range(var.chassis_9508_count)

  # Convert the list of numbers to a set of strings
  chassis_index_set     = toset([for v in local.chassis_index_numbers : tostring(v)])

  # Create a list of Chassis Profile moids
  chassis_profile_moids = [for n in local.chassis_index_numbers : intersight_chassis_profile.chassis_9508_profile[n].id]
  # chassis_profile_moids = intersight_chassis_profile.chassis_9508_profile[2].id

  # Create a list of Chassis Profile moids
  chassis_profile_names = [for n in local.chassis_index_numbers : intersight_chassis_profile.chassis_9508_profile[n].name]
 
  # var.switch_vlans_6454      # Example: "2-100,105,110,115 >> {"vlan-2": 2, "vlan-3": 3, etc}"
  vlan_split = length(regexall("-", var.switch_vlans_6454)) > 0 ? tolist(
    split(",", var.switch_vlans_6454)
  ) : tolist(var.switch_vlans_6454)
  vlan_lists = [for s in local.vlan_split : length(regexall("-", s)) > 0 ? [
    for v in range(
      tonumber(element(split("-", s), 0)),
      (tonumber(element(split("-", s), 1)
    ) + 1)) : tonumber(v)] : [s]
  ]
  flattened_vlan_list = flatten(local.vlan_lists)
  vlan_list_set       = toset(local.flattened_vlan_list)

}
