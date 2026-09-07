variable "terminal_life" {
	description = "Product variable"
	type = object({
	  name = string
	  cpu = number
	  ram = number
	  disk = number
	  disk_name = string
	  image_id = string
	})
}

variable "folder_id" {
  type    = string
  default = ""
}
variable "zone" {
  type    = string
  default = "ru-central1-d"
}
variable "service_account_key_file" {
  type    = string
  default = ""
}
variable "my_ip" {
  type    = string
  default = ""
}

variable "subnet_mask" {
  type = string
  default = "192.168.1.0/24"
}