# The following are defined as "local" variables (local.<variable>)
# Local variables are typically used for data transformation or to set frequently used values
# Local variables are accessed with:  local.<var-name>
# Note: Sensitive information should be stored in variables (var.<variable>) to be passed in
#       from TFCB, CLI parameters or environment variables

#__________________________________________________________
#
# Local Variables Section
#__________________________________________________________

locals {

  org_moid = data.intersight_organization_organization.my_org.id  

# The chassis is initially set to "Number" value
  chassis_9508_count = 5

# This section shows built-in Terraform functions for transforming data values

  # Create a list of chassis indexes Example of five starting at 1: [1,2,3,4,5]
  chassis_index_numbers  = range(1,local.chassis_9508_count + 1)

  # Convert the list of numbers to a set of strings  - now it can be used by "for_each"
  chassis_index_set     = toset([for v in local.chassis_index_numbers : tostring(v)])



  # Create a list of Chassis Profile moids
  chassis_profile_moids = [for n in local.chassis_index_numbers : intersight_chassis_profile.chassis_9508_profile[n].id]
  # Example, accessing moid #2 in Array of 5 chassis objects:  intersight_chassis_profile.chassis_9508_profile[2].id

  # Create a list of Chassis Profile names
  chassis_profile_names = [for n in local.chassis_index_numbers : intersight_chassis_profile.chassis_9508_profile[n].name]
 
}