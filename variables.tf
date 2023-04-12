variable "region" {
  type        = string
  description = "AWS region where you want to deploy your resources."
}

variable "profile" {
  type        = string
  description = "AWS CLI profile configured locally."
  default     = "default"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default     = "t2.micro"
}

variable "instance_name" {
  type        = string
  description = "EC2 instance name."
  default     = "cod2-primary"
}

variable "mysql_root_password" {
  type        = string
  description = "Password that will be set for MySQL root user."
}

variable "aws_access_key_id" {
  type        = string
  description = "AWS Access Key Id configured with S3 read permission."
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS Secret Access Key configured with S3 read permission."
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the bucket that is hosting server files."
}
