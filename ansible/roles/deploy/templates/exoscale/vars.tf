variable "EXOSCALE_ACCESS" {
  type = string
}
variable "EXOSCALE_SECRET" {
  type = string
}
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
