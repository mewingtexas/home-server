# --- Proxmox API Connection Variables ---

variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token" {
    type = string
    sensitive = true
}

variable "proxmox_root_password" {
    type = string
    sensitive = true
}

variable "proxmox_node" {
    type = string
    default = "pve"
}

variable "storage" {
    type = string
    default = "local-lvm"
}

# --- Network Gateway Variables --- 

variable "infrastructure_gateway" {
    type = string
    description = "Default gateway for infrastructure VLAN"
}

variable "media_gateway" {
    type = string
    description = "Default gateway for media VLAN"
}

# --- Operatingn System Container Variables ---

variable "pihole_template" {
    type = string
    default = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
}

variable "prometheus_template" {
    type = string
    default = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
}

variable "DB_template" {
    type = string
    default = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
}

variable "Jellyfin_template" {
    type = string
    default = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
}

# --- Static Networking Configurations (IPs in CIDR notation) ---

variable "pihole_ip" {
    type = string
}

variable "prometheus_ip" {
    type = string
}

variable "DB_ip" {
    type = string
}

variable "Jellyfin_ip" {
    type = string
}

# --- Container Password Variables ---

variable "pihole_password" {
    type = string
    sensitive = true
}

variable "prometheus_password" {
    type = string
    sensitive = true
}

variable "DB_password" {
    type = string
    sensitive = true
}

variable "Jellyfin_password" {
    type = string
    sensitive = true
}


