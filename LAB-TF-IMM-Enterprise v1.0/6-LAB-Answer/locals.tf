# =============================================================================
# Local Variables 
# Usage: local.<variable>
# Local variables are typically used for data transformation or to set frequently used values
# -----------------------------------------------------------------------------

locals {

  org_moid = data.intersight_organization_organization.my_org.id
  
  #secretkey = file("../SecretKey.txt")
  #secretkey = var.secretkey

# The chassis is initially set to "Number" value
  chassis_9508_count = 5


  # Creates a list of chassis indexes - example of five starting at one: [1,2,3,4,5]  >> range(1,6)
  chassis_index_numbers  = range(1,local.chassis_9508_count + 1)

  # Converts the list of numbers to a set of strings  - now it can be used by "for_each"
  chassis_index_set     = toset([for v in local.chassis_index_numbers : tostring(v)])



  # Creates a list of Chassis Profile moids
  chassis_profile_moids = [for n in local.chassis_index_numbers : intersight_chassis_profile.chassis_9508_profile[n].id]
  # Example, accessing moid #2 in Array of 5 chassis objects:  intersight_chassis_profile.chassis_9508_profile[2].id

  # Creates a list of Chassis Profile names
  chassis_profile_names = [for n in local.chassis_index_numbers : intersight_chassis_profile.chassis_9508_profile[n].name]
 
}