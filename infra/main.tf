# Create boot disks
resource "yandex_compute_disk" "boot-disk" {
  count    = 2
  zone     = var.yc_zone
  name     = "${var.disk_name}-${count.index}"
  type     = var.disk_type
  size     = var.disk_size
  image_id = var.ubuntu_image_id
}

# Create compute instances
resource "yandex_compute_instance" "vm" {
  count                     = 2
  name                      = "${var.yc_instance_name}-${count.index}"
  zone                      = var.yc_zone
  platform_id               = "standard-v3"
  allow_stopping_for_update = true

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk[count.index].id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.yc_instance_user_name}:${file(var.public_key_path)}"
    user-data = templatefile("${path.root}/scripts/setup.sh", {
      user_name                 = var.yc_instance_user_name
      gitlab_registration_token = var.gitlab_registration_token
      gitlab_url                = var.gitlab_url
    })
  }

  connection {
    type        = "ssh"
    user        = var.yc_instance_user_name
    private_key = file(var.private_key_path)
    host        = self.network_interface.0.nat_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cloud-init status --wait",
      "echo 'setup script execution log:' | sudo tee /var/log/setup_execution.log",
      "sudo cat /var/log/cloud-init-output.log | sudo tee -a /var/log/setup_execution.log",
    ]
  }

  depends_on = [yandex_vpc_subnet.subnet]
}

# resource "null_resource" "save_external_ip" {
#   triggers = {
#     instance_id = yandex_compute_instance.vm.id
#   }

#   provisioner "local-exec" {
#     # сохранить внешний IP-адрес в файл .env
#     command = <<EOT
#       # Сохранение внешнего IP-адреса в переменную
#       EXTERNAL_IP=${yandex_compute_instance.vm.network_interface.0.nat_ip_address}

#       # Замена в .env файла переменной SERVER_IP
#       sed -i "s/^SERVER_IP=.*/SERVER_IP=$EXTERNAL_IP/" ../.env
#     EOT
#   }
# }

# # Output the external IP address of the instance
# output "external_ip_address_vm" {
#   value = yandex_compute_instance.vm.network_interface.0.nat_ip_address
# }
