variable "region" {
  type        = string
  description = "AWS region where you want to deploy your resources."
}

variable "profile" {
  type        = string
  description = "AWS CLI profile configured locally."
  default = "default"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default = "t2.micro"
}

variable "instance_name" {
  type        = string
  description = "EC2 instance name."
  default = "cod2-primary"
}
