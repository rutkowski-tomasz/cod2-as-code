resource "tls_private_key" "primary_server_key" {
  algorithm = "RSA"
  rsa_bits  = 4096

  provisioner "local-exec" {
    command = "rm ~/.ssh/${var.instance_name}_key.pem || true"
  }
}

resource "aws_key_pair" "primary_server_key" {
  key_name   = "${var.instance_name}-key"
  public_key = tls_private_key.primary_server_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.primary_server_key.private_key_pem}' > ~/.ssh/${var.instance_name}_key.pem && chmod 400 ~/.ssh/${var.instance_name}_key.pem"
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "primary_server_sg" {
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

  ingress {
    description = "CoD2 ports"
    from_port   = 28960
    to_port     = 28960
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MySQL"
    from_port   = 3307
    to_port     = 3307
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "phpmyadmin"
    from_port   = 8080
    to_port     = 8080
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

resource "aws_instance" "primary_server" {
  ami                    = "ami-0ec7f9846da6b0f61"
  instance_type          = var.instance_type
  key_name               = aws_key_pair.primary_server_key.key_name
  vpc_security_group_ids = [aws_security_group.primary_server_sg.id]

  tags = {
    Name = var.instance_name
  }

  root_block_device {
    volume_size           = var.instance_disk_size
    volume_type           = "gp2"
    encrypted             = false
    delete_on_termination = true
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.primary_server_key.private_key_pem
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "setup/"
    destination = "/home/ubuntu/"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x -R ~/scripts",
      "~/scripts/start.sh --mysql_root_password=${var.mysql_root_password} --aws_access_key_id=${var.aws_access_key_id} --aws_secret_access_key=${var.aws_secret_access_key} --s3_bucket_name=${var.s3_bucket_name} --s3_bucket_region=${var.s3_bucket_region} --domain=${var.domain}"
    ]
  }
}
