data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "servers_main_sg" {
  name        = "${var.instance_name}-sg"
  description = "${var.instance_name} instace security group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "CoD2 ports"
    from_port   = 28960
    to_port     = 28960
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "servers_main" {
  ami                    = "ami-0ec7f9846da6b0f61"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.servers_main_sg.id]

  tags = {
    Name = var.instance_name
  }
}
