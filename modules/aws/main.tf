resource "aws_instance" "host" {
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.aws_vpc_subnet.id #Grab ID from aws_subnet resource
  ami                         = var.ami
  instance_type               = var.size
  key_name                    = aws_key_pair.host_key.key_name #Grab key name from aws_key_pair resource
  availability_zone           = aws_subnet.aws_vpc_subnet.availability_zone
  depends_on                  = [aws_key_pair.host_key]
  root_block_device {
    delete_on_termination = var.delete_root_volume
  }

  tags = {
    Name = var.name
  }
  provisioner "remote-exec" {
    inline = ["echo 'Im alive!'"]

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file("./id_rsa")
      host        = aws_instance.host.public_ip
    }
  }
}

resource "aws_key_pair" "host_key" { # aws_key_pair resource
  key_name   = var.name
  public_key = file("./id_rsa.pub")
}
resource "aws_vpc" "aws_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "aws_vpc_subnet" { # aws_subnet resource 
  cidr_block = var.vpc_subnet
  vpc_id     = aws_vpc.aws_vpc.id
  depends_on = [aws_vpc.aws_vpc]
}

resource "aws_internet_gateway" "aws_igw" {
  vpc_id     = aws_vpc.aws_vpc.id
  depends_on = [aws_vpc.aws_vpc]
}

resource "aws_route_table" "subnet_rt" {
  vpc_id     = aws_vpc.aws_vpc.id
  depends_on = [aws_vpc.aws_vpc]
}


resource "aws_route" "subnet_default_route" {
  route_table_id         = aws_route_table.subnet_rt.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.subnet_rt]
  gateway_id             = aws_internet_gateway.aws_igw.id
}

resource "aws_route_table_association" "rt_assoc_" {
  route_table_id = aws_route_table.subnet_rt.id
  subnet_id      = aws_subnet.aws_vpc_subnet.id
}

resource "aws_security_group" "instance_sg" {
  vpc_id     = aws_vpc.aws_vpc.id
  depends_on = [aws_vpc.aws_vpc]
}

resource "aws_security_group_rule" "ingress_all" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.instance_sg.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_all" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.instance_sg.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
