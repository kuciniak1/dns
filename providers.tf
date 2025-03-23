terraform {
    required_providers {    
        proxmox = {
            source = "telmate/proxmox"
            version = "3.0.1-rc4"
        }
    }

    backend "s3" {
        bucket         = "tf-backend"
        key            = "dns/terraform.tfstate"
        region         = "eu-central-003"
        endpoint       = "s3.eu-central-003.backblazeb2.com"
        profile        = "backblaze"
    
        skip_credentials_validation = true
        skip_region_validation      = true
        skip_metadata_api_check     = true
        use_path_style              = true
        skip_requesting_account_id  = true
        skip_s3_checksum            = true
    }
}

provider "proxmox" {
    pm_api_url = var.proxmox_api_url
    pm_api_token_id = var.proxmox_api_token_id
    pm_api_token_secret = var.proxmox_api_token_secret
    pm_tls_insecure = var.proxmox_tls_insecure
}