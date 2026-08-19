output "bastion_public_ip" { value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address }
output "web-1_internal_ip" { value = yandex_compute_instance.web-1.network_interface.0.ip_address }
output "web-2_internal_ip" { value = yandex_compute_instance.web-2.network_interface.0.ip_address }
