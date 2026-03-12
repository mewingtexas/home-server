variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token" {
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

variable "pihole_template" {
    type = string
    default = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
}

variable "prometheus_template" {
    type = string
    default = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
}

variable "gateway" {
    type = string
    description = "Default gateway for any said VLAN"
}

variable "pihole_ip" {
    type = string
    description = "Static IP in CIDR, e.g. 192.168.60.10"
}

variable "prometheus_ip" {
    type = string
    description = "Static IP in CIDR, e.g. 192.168.60.20"
}

variable "pihole_password" {
    type = string
    sensitive = true
}

variable "prometheus_password" {
    type = string
    sensitive = true
}
