variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
    sensitive = true
}

variable "proxmox_tls_insecure" {
    type = bool
    default = true
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

variable "container_id" {
    type = number
}

variable "container_ip" {
    type = string
}


variable "container_ssh_key" {
    type = string
}