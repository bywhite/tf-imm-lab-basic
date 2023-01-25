# =============================================================================
# vMedia Related Server Policies
#  - vMedia Policy
#  - KVM Policy
#  - 
# -----------------------------------------------------------------------------



# =============================================================================
# Virtual Media Policy
# -----------------------------------------------------------------------------

resource "intersight_vmedia_policy" "vmedia_1" {
  name          = "${var.server_policy_prefix}-vmedia-enabled"
  description   = var.description
  enabled       = true
  encryption    = true
  low_power_usb = true
  organization {
    moid        = var.organization
    object_type = "organization.Organization"
  }
  
  # profiles {
  #   moid    = intersight_server_profile_template.server_template_1.moid
  #   object_type = "server.ProfileTemplate"
  # }

  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  # depends_on = [
  #   intersight_server_profile_template.server_template_1
  # ]
}


/**
resource "intersight_vmedia_policy" "vmedia1" {
  name          = "${var.server_policy_prefix}-vmedia-ubuntu-policy-1"
  description   = var.description
  enabled       = true
  encryption    = false
  low_power_usb = true
  mappings = [{
    additional_properties   = ""
    authentication_protocol = "none"
    class_id                = "vmedia.Mapping"
    device_type             = "cdd"
    file_location           = "infra-chx.auslab.cisco.com/software/linux/ubuntu-18.04.5-server-amd64.iso"
    host_name               = "infra-chx.auslab.cisco.com"
    is_password_set         = false
    mount_options           = "RO"
    mount_protocol          = "nfs"
    object_type             = "vmedia.Mapping"
    password                = ""
    remote_file             = "ubuntu-18.04.5-server-amd64.iso"
    remote_path             = "/iso/software/linux"
    sanitized_file_location = "infra-chx.auslab.cisco.com/software/linux/ubuntu-18.04.5-server-amd64.iso"
    username                = ""
    volume_name             = "IMC_DVD"
  }]
  organization {
    moid        = var.organization
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
**/


# =============================================================================
# KVM Policy
# -----------------------------------------------------------------------------

resource "intersight_kvm_policy" "kvmpolicy_1" {
  name                      = "${var.server_policy_prefix}-kvm-enabled"
  description               = var.description
  enable_local_server_video = true
  enable_video_encryption   = true
  enabled                   = true
  maximum_sessions          = 4
  organization {
    moid = var.organization
  }
  #attached under policy template policy bucket
  remote_port = 2068
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
