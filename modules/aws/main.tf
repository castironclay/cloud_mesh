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

resource "random_shuffle" "regions" {
  input = [
    "us-east-2",      # US East (Ohio)
    "us-east-1",      # US East (N. Virginia)
    "us-west-2",      # US West (Oregon)
    "ap-south-1",     # Asia Pacific (Mumbai)
    "ap-northeast-2", # Asia Pacific (Seoul)
    "ap-southeast-1", # Asia Pacific (Singapore)
    "ap-southeast-2", # Asia Pacific (Sydney)
    "ap-northeast-1", # Asia Pacific (Tokyo)
    "ca-central-1",   # Canada (Central)
    "eu-central-1",   # EU (Frankfurt)
    "eu-west-1",      # EU (Ireland)
    "eu-west-2",      # EU (London)
    "eu-west-3",      # EU (Paris)
    "eu-north-1",     # EU (Stockholm)
  ]
  result_count = 1
}
