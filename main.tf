resource "aws_instance" "servers_main" {
  ami                    = "ami-0ec7f9846da6b0f61"
  instance_type          = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
