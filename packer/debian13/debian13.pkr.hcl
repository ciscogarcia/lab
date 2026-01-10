packer {
  required_plugins {
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

source "virtualbox-iso" "debian13" {
  http_directory = "http"
  boot_command = [
    "<esc><wait>",
    "auto<wait>",
    " auto-install/enable=true",
    " debconf/priority=critical",
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait>",
	" lowmem/low=note",
    " -- <wait>",
    "<enter><wait>"
  ]
  guest_os_type    = "Debian13_64"
  iso_url          = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.2.0-amd64-netinst.iso"
  iso_checksum     = "677c4d57aa034dc192b5191870141057574c1b05df2b9569c0ee08aa4e32125d"
  ssh_username     = "vagrant"
  ssh_password     = "vagrant"
  ssh_timeout = "1h"
  disk_size = 10000
  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
}

build {
  sources = ["sources.virtualbox-iso.debian13"]
  provisioner "shell" {
	script="vagrant.sh"
  }
  post-processors {
	post-processor "vagrant" {
	  provider_override = "virtualbox"
	  keep_input_artifact = true
	  output="debian-golden.box"
	}
  }
}


# { = [{
#     "type": "vagrant",
#     "keep_input_artifact": true,
#     "output": "mycentos.box"
#   }]
