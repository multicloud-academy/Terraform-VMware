provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vcenter_fqdn}"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "MCloud DC1"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "HomeLab Cluster"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = "DS-Local-ESXi03"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "VM-02-Ubuntu"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "${var.VM}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 2048
  firmware = var.vm_firmware
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type
  wait_for_guest_net_timeout = 60 
 

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = false
    thin_provisioned = true
    
   
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
    host_name = "mterraform-linux-vm"
    domain    = "local"
  }
    
        network_interface {
            ipv4_address = "192.168.1.80"
            ipv4_netmask = "24"
            dns_server_list = ["192.168.1.10"]
            dns_domain = "dc.com"
        }
        ipv4_gateway    = "192.168.1.254"
    }
  }
}

output "ID" {
    value = "${data.vsphere_network.network.id}"
}
