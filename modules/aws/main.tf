resource "aws_lightsail_instance" "instance" {
  name              = var.name
  availability_zone = "${random_shuffle.regions.result[0]}a"
  blueprint_id      = "debian_12"
  bundle_id         = "nano_3_0"
  key_pair_name     = aws_lightsail_key_pair.key_pair.name
}

resource "aws_lightsail_key_pair" "key_pair" {
  name       = "${var.name}_key"
  public_key = file(var.public_keyname)
}

resource "aws_lightsail_instance_public_ports" "ports" {
  instance_name = aws_lightsail_instance.instance.name

  port_info {
    cidr_list_aliases = []
    cidrs             = ["0.0.0.0/0"]
    protocol          = "tcp"
    from_port         = 22
    to_port           = 22
  }
}

resource "random_shuffle" "regions" {
  input = ["us-east-1", "us-east-2", "us-west-2", "ca-central-1",
  "eu-west-1", "eu-west-2", "eu-west-3", "eu-central-1", "eu-north-1"]
  result_count = 1
}
