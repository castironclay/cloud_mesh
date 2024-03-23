variable "VULTR_TOKEN" {}
variable "name" {
  type    = string
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
