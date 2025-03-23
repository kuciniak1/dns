resource "proxmox_lxc" "dns-bind" {
    target_node = "proxmox"
    arch = "amd64"
    hostname = "dns"
    vmid = var.container_id


    ostemplate = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"

    ssh_public_keys = var.container_ssh_key

    unprivileged = true

    memory = 1024

    start = true

    rootfs {
      storage = "local-lvm"
      size = "10G"
    }

    network {
      name = "eth0"
      bridge = "vmbr0"
      gw = "192.168.0.1"
      ip = "${var.container_ip}/24"
    }


    connection {
      host = var.container_ip
      user        = "root"
      private_key = file("~/.ssh/dns")
      agent       = false
    }

    provisioner "remote-exec" {
      inline = [
        "apt update",
        "apt install -y bind9 bind9utils bind9-doc dnsutils",
        "mkdir -p /var/lib/bind/dynamic",
        "chown bind:bind /var/lib/bind/dynamic",
        "chmod 775 /var/lib/bind/dynamic"
      ]
    }
    provisioner file {
      source = "files/forward.kuciniak.local"
      destination = "/var/lib/bind/dynamic/forward.kuciniak.local"
    }

    provisioner file {
      source = "files/reverse.kuciniak.local"
      destination = "/var/lib/bind/dynamic/reverse.kuciniak.local"
    }

    provisioner file {
      source = "files/named.conf.local"
      destination = "/etc/bind/named.conf.local"
    }

    provisioner file {
      source = "files/named.conf.options"
      destination = "/etc/bind/named.conf.options"
    }

    provisioner file {
      source = "files/named"
      destination = "/etc/default/named"
    }

    provisioner remote-exec {
      inline = [
        "systemctl restart named"
      ]
    }
  }

