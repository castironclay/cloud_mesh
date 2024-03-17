variable "linode_image" {
  default = "linode/debian12"
}

variable "linode_label" {
  default = "namenamenamename"
}

variable "linode_type" {
  default = "g6-standard-1"
}

variable "key_name" {
  default = "namenamenamename"
}

variable "private_keyname" {
  default = "./prikey"
  type    = string
}

variable "public_keyname" {
  default = "./pubkey"
  type    = string
}

variable "LINODE_TOKEN" {}
