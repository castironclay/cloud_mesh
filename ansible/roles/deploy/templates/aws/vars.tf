variable "size" {
  default     = "t3.micro"
  description = "Size of EC2 instance"
  type        = string
}
variable "delete_root_volume" {
  default     = "true"
  description = "Delete root volume of instance after removal"
  type        = string
}

variable "name_of_key" {
  default = "namenamenamename"
  type    = string
}

variable "vpc_cidr" {
  default = "192.168.0.0/16"
}

variable "vpc_subnet" {
  default = "192.168.0.0/24"
}

variable "wg_port" {
  default = "wireguardport"
  type    = string
}

variable "name" {
  default = "namenamenamename"
  type    = string
}

variable "ami" {
  description = "Debian 11"
  default     = "ami-05d7b6ab484d095b3"
  type        = string
}

variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
