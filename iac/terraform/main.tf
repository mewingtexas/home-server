resource "proxmox_virtual_environment_container" "pihole" {
  node_name   = var.proxmox_node
  vm_id       = 200
  description = "Pi-hole DNS container"
  started     = true
  unprivileged = true

  initialization {
    hostname = "pihole"

    ip_config {
      ipv4 {
        address = var.pihole_ip
        gateway = var.gateway
      }
    }

    user_account {
      password = var.pihole_password
    }
  }

  network_interface {
    name    = "eth0"
    bridge  = "vmbr0"
    vlan_id = 60
  }

  operating_system {
    template_file_id = var.pihole_template
    type             = "debian"
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 512
    swap      = 512
  }

  disk {
    datastore_id = var.storage
    size         = 8
  }

  features {
    nesting = true
  }
}

resource "proxmox_virtual_environment_container" "prometheus" {
  node_name   = var.proxmox_node
  vm_id       = 201
  description = "Prometheus container"
  started     = true
  unprivileged = true

  initialization {
    hostname = "prometheus"

    ip_config {
      ipv4 {
        address = var.prometheus_ip
        gateway = var.gateway
      }
    }

    user_account {
      password = var.prometheus_password
    }
  }

  network_interface {
    name    = "eth0"
    bridge  = "vmbr0"
    vlan_id = 60
  }

  operating_system {
    template_file_id = var.prometheus_template
    type             = "debian"
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 1024
    swap      = 1024
  }

  disk {
    datastore_id = var.storage
    size         = 16
  }

  features {
    nesting = false
  }
}
