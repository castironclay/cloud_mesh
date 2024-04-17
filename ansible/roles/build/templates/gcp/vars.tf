variable "name" {
  default     = "namenamenamename"
  description = "Name of compute instance"
}

variable "private_keyname" {
  default = "./prikey"
  type    = string
}

variable "public_keyname" {
  default = "./pubkey"
  type    = string
}

variable "GCP_PROJECT" {}
variable "GCP_CREDS" {}
