terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = var.oauth_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "network-1" { name = "network-1" }

resource "yandex_vpc_subnet" "subnet-a" {
  name           = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet-b" {
  name           = "subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"
  resources { cores = 2, memory = 2, core_fraction = 20 }
  scheduling_policy { preemptible = true }
  boot_disk { initialize_params { image_id = var.ubuntu_image_id, type = "network-hdd", size = 10 } }
  network_interface { subnet_id = yandex_vpc_subnet.subnet-a.id, nat = true }
  metadata = { user-data = file("./meta.yaml") }
}

resource "yandex_compute_instance" "web-1" {
  name        = "web-1"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"
  resources { cores = 2, memory = 2, core_fraction = 20 }
  scheduling_policy { preemptible = true }
  boot_disk { initialize_params { image_id = var.ubuntu_image_id, type = "network-hdd", size = 10 } }
  network_interface { subnet_id = yandex_vpc_subnet.subnet-a.id, nat = false }
  metadata = { user-data = file("./meta.yaml") }
}

resource "yandex_compute_instance" "web-2" {
  name        = "web-2"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"
  resources { cores = 2, memory = 2, core_fraction = 20 }
  scheduling_policy { preemptible = true }
  boot_disk { initialize_params { image_id = var.ubuntu_image_id, type = "network-hdd", size = 10 } }
  network_interface { subnet_id = yandex_vpc_subnet.subnet-b.id, nat = false }
  metadata = { user-data = file("./meta.yaml") }
}
