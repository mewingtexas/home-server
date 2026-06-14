terraform {

    required_providers {
        proxmox = {
            source = "bpg/proxmox"
            version = ">=0.60.0"
        }
    }

}

provider "proxmox" {

    endpoint = var.proxmox_api_url
    api_token = var.proxmox_api_token
    insecure = true

    username = "root@pam"
    password = "${var.proxmox_root_password}"
}

