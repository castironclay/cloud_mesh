variable "region" {
  default = "nyc3"
  type    = string
}
variable "name" {
  default = "namenamenamename"
  type    = string
}

variable "private_keyname" {
  default = "./prikey"
  type    = string
}

variable "public_keyname" {
  default = "./pubkey"
  type    = string
}

variable "DO_TOKEN" {
  type = string
}
