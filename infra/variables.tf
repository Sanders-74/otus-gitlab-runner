# Define variables
variable "yc_token" {
  type = string
}

variable "yc_cloud_id" {
  type = string
}

variable "yc_folder_id" {
  type = string
}

variable "yc_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "yc_instance_name" {
  type = string  
}

variable "yc_network_name" {
  type = string
}

variable "yc_subnet_name" {
  type = string
}

variable "ubuntu_image_id" {
  type    = string
}

variable "public_key_path" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "disk_name" {
  type = string
}

variable "disk_type" {
  type = string
}

variable "disk_size" {
  type = number
}

variable "yc_instance_user_name" {
  type    = string
  default = "ubuntu"
}

variable "gitlab_url" {
  type = string
}

variable "gitlab_registration_token" {
  type = string
}