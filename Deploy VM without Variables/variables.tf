variable "vsphere_user" {
 type = string  
 description = "Enter username for vcenter"
  }

  variable "vsphere_password" {
    type = string
    description = "Enter password for vcenter"
    }

  variable "vcenter_fqdn" {
    type = string
    description = "Enter vcenter FQDN"
  }

variable "VM" {
    type = string
    description = "Enter VM Name"

  }

variable "allow_unverified_ssl" {
  type = bool
  default = true
}

variable "vm_firmware" {
  type = string
  description = "Firmware: bios or efi"
 
}

