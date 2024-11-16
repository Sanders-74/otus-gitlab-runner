# Create a VPC network
resource "yandex_vpc_network" "network" {
  name = var.yc_network_name
}

# Create a subnet
resource "yandex_vpc_subnet" "subnet" {
  name           = var.yc_subnet_name
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}