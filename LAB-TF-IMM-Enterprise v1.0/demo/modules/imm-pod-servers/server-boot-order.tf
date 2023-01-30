# =============================================================================
# Server Precision Boot Order Policies for FI-Attached server template
# Creates "Boot Order Policy"
# Examples: https://github.com/terraform-cisco-modules/terraform-intersight-imm/blob/master/examples/policies/boot_order_policies.tf
# -----------------------------------------------------------------------------

resource "intersight_boot_precision_policy" "boot_precision_1" {
  name                     = "${var.server_policy_prefix}-boot-order-policy-1"
  description              = var.description
  configured_boot_mode     = "Uefi"
  enforce_uefi_secure_boot = false
  organization {
    moid        = var.organization
    object_type = "organization.Organization"
  }

  boot_devices {
    enabled     = true
    name        = "KVM_DVD"
    object_type = "boot.VirtualMedia"
     additional_properties = jsonencode({
       Subtype = "kvm-mapped-dvd"
    })
  }

  boot_devices {
    enabled     = true
    name        = "IMC_DVD"
    object_type = "boot.VirtualMedia"
    additional_properties = jsonencode({
      Subtype = "cimc-mapped-dvd"
    })
  }

  boot_devices {
    enabled     = true
    name        = "M2_Boot"
    object_type = "boot.LocalDisk"
    additional_properties = jsonencode({
      Slot    = "MSTOR-RAID"
      Bootloader = {
        Description = "M2 Boot"
        Name        = "BOOTX64.EFI"
        ObjectType  = "boot.Bootloader"
        Path        = "\\EFI\\BOOT\\"
      }
    })
  }

  boot_devices {
    enabled     = true
    name        = "RAID_Boot"
    object_type = "boot.LocalDisk"
    additional_properties = jsonencode({
      Slot       = "MRAID"
      Bootloader = {
        Description = "RAID Boot"
        Name        = "BOOTX64.EFI"
        ObjectType  = "boot.Bootloader"
        Path        = "\\EFI\\BOOT\\"
      }
    })
  }

  boot_devices {
    enabled         = true
    name            = "PXE"
    object_type     = "boot.Pxe"
    additional_properties = jsonencode({
      Slot            = "MLOM"
      InterfaceSource = "name"
      InterfaceName   = "eth0"
      IpType          = "IPv4"
    })
  }

#       Port           = "-1"
#      MacAddress     = ""

  # boot_devices {
  #   enabled     = true
  #   name        = "interfacename"
  #   object_type = "boot.San"
  #     additional_properties = jsonencode({
  #       Bootloader = {
  #           ClassId     = "boot.Bootloader"
  #           Description = "rhel",
  #           Name        = "bootx64.efi",
  #           ObjectType  = "boot.Bootloader"
  #           Path        = "\\EFI\\BOOT\\BOOTx64.EFI"
  #         }
  #       InterfaceName = "fc0"
  #       Lun           = 0
  #       Slot          = "MLOM"
  #       Wwpn          = "20:00:00:25:B5:00:01:ff"
  #     })
  # }

  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


### Legacy Boot options follow
# Reference: 
# https://registry.terraform.io/providers/CiscoDevNet/Intersight/latest/docs/resources/boot_precision_policy

# UEFI Examples
# https://github.com/scotttyso/terraform-intersight-easy-imm/blob/master/modules/policies/boot_order_policies.tf

## example from tf-int-imm module by Tyson >> Needs translation and legacy mode used
# module "boot_legacy_san" {
#   depends_on = [
#     data.intersight_organization_organization.org_moid
#   ]
#   source      = "terraform-cisco-modules/imm/intersight//modules/boot_order_policies"
#   boot_mode   = "Legacy"
#   description = "Legacy SAN Boot Example."
#   name        = "example_legacy_san"
#   org_moid    = local.org_moid
#   profiles    = []
#   tags        = var.tags
#   boot_devices = [
#     {
#       additional_properties = jsonencode(
#         {
#           InterfaceName = "vHBA-A",
#           Lun           = 0,
#           Slot          = "MLOM",
#           Wwpn          = "20:00:00:25:B5:00:01:ff"
#         }
#       )
#       enabled     = true,
#       name        = "SAN_A_Boot",
#       object_type = "boot.San",
#     },
#   ]
# }
#
## Legacy HDD boot
#
  # boot_devices {
  #   enabled     = true
  #   name        = "hdd"
  #   object_type = "boot.LocalDisk"
  #   additional_properties = jsonencode({
  #     Slot = "MRAID"
  #     Bootloader = {
  #       Description = ""
  #       Name        = ""
  #       ObjectType  = "boot.Bootloader"
  #       Path        = ""
  #     }
  #   })
  # }
#

#
# boot_devices {
#     enabled     = true
#     name        = "scu-device-hdd"
#     object_type = "boot.LocalDisk"
#     additional_properties = jsonencode({
#       Slot = "MRAID"
#       Bootloader = {
#         Description = ""
#         Name        = ""
#         ObjectType  = "boot.Bootloader"
#         Path        = ""
#       }
#     })
#   }
#
## Legacy Boot vMedia
#
  # boot_devices {
  #   enabled     = true
  #   name        = "NIIODCIMCDVD"
  #   object_type = "boot.VirtualMedia"
  #   additional_properties = jsonencode({
  #     Subtype = "cimc-mapped-dvd"
  #   })
  # }
  #

# Legacy M2 Boot
    # boot_devices {
  #   enabled     = true
  #   name        = "M2-RAID"
  #   object_type = "boot.LocalDisk"
  #      additional_properties = jsonencode({
  #       slot        = "MSTOR-RAID"
  #   })
  # }