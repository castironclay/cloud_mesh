variable "location" {
  default     = "eastus"
  description = "Specifies the Azure Region where the Virtual Machine exists.Changing this forces a new resource to be created."
}

variable "network" {
  default     = "172.16.0.0/16"
  description = "Supernet for virtual machine"
}

variable "subnet" {
  default     = "172.16.1.0/24"
  description = "Subnet for virtual machine"
}
variable "name" {
  default     = "namenamenamename"
  description = "Specifies the name of the Virtual Machine. Changing this forces a new resource to be created."
}

variable "size" {
  default     = "Standard_DS1_v2"
  description = "Specifies the size of the Virtual Machine."
}

variable "wg_port" {
  default = "wireguardport"
}

variable "username" {
  default = "debian"
}

variable "AZ_TENANT" {}
variable "AZ_SECRET" {}
variable "AZ_APP_ID" {}
variable "AZ_SUB_ID" {}
