terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.49.0"
    }
  }
}

provider "yandex" {
  zone      = "ru-central1-c"
}

data "yandex_compute_image" "container-optimized-image" {
  family = "container-optimized-image"
}

resource "yandex_vpc_network" "network-1" {
  name = "wireguard-network"
}

resource "yandex_vpc_subnet" "subnet-public" {
  name           = "subnet1"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.42.0/24"]
}

resource "yandex_compute_instance" "vm-wireguard" {
  name = "wireguard-instance"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-public.id
    nat       = true
  }

  metadata = {
    ssh-keys = "yc-user:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "external_ip_address_vm_wireguard" {
  value = yandex_compute_instance.vm-wireguard.network_interface.0.nat_ip_address
}
