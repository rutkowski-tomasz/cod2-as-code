output "public_ip" {
  value       = aws_instance.primary_server.public_ip
  description = "The IP of created server."
}

output "mysql_root_password" {
  value       = var.mysql_root_password
  description = "The password for logging in to the database."
  sensitive   = true
}

output "connection_string" {
  value       = "/connect ${aws_instance.primary_server.public_ip}"
  description = "CoD2 console command for connecting to created server."
}