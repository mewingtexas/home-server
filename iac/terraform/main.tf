# ==========================================
# Networking / Infrastructure
# ==========================================

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
        gateway = var.infrastructure_gateway
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
        gateway = var.infrastructure_gateway
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

# ==========================================
# 1. Download & Automation 
# Includes: Gluetun, qBittorrent, Sonarr, Radarr, Prowlarr
# ==========================================

resource "proxmox_virtual_environment_container" "DB" {

  node_name    = var.proxmox_node
  vm_id        = 100 
  description  = "Download & Automation Stack (Gluetun, qBittorrent, Arrs)"
  started      = true
  unprivileged = true 

  initialization {
    hostname = "download-box"

    ip_config {
      ipv4 {
        address = var.DB_ip 
        gateway = var.media_gateway
      }
    }

    user_account {
      password = var.DB_password 
    }
  }

  network_interface {
    name    = "eth0"
    bridge  = "vmbr0"
    vlan_id = 50 
  }

  operating_system {
    template_file_id = var.DB_template 
    type             = "debian"
  }

  cpu {
    cores = 2 
  }

  memory {
    dedicated = 1536 
    swap      = 512 
  }

  disk {
    datastore_id = var.storage 
    size         = 20        
  }

  features {
    nesting = true
    keyctl  = true
  }

  # download stack needs entire storage directory for downloads and media
  mount_point {
    volume = "/mnt/storage"
    path   = "/data"
  }
}

# ==========================================
# 2. Streaming
# Jellyfin lxc for media streaming
# ==========================================

resource "proxmox_virtual_environment_container" "jellyfin_server" {
  node_name    = var.proxmox_node
  vm_id        = 101
  description  = "Dedicated Jellyfin Media Server"
  started      = true
  unprivileged = true

  initialization {
    hostname = "jellyfin"

    ip_config {
      ipv4 {
        address = var.Jellyfin_ip 
        gateway = var.media_gateway
      }
    }

    user_account {
      password = var.Jellyfin_password
    }
  }

  network_interface {
    name    = "eth0"
    bridge  = "vmbr0"
    vlan_id = 50
  }

  operating_system {
    template_file_id = var.Jellyfin_template 
    type             = "debian"
  }

  cpu {
    cores = 4
  }

  memory {
    dedicated = 2048
    swap      = 1024 
  }

  disk {
    datastore_id = var.storage 
    size         = 20          
  }

  features {
    nesting = true
    keyctl  = true
  }

  # jellyfin only needs media directory
  mount_point {
    volume = "/mnt/storage/media"  
    path   = "/data/media"        
    read_only = true
  }
}