variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-west-2"
}

variable "vpc_id" {
  description = "The VPC ID to create resources in."
  type        = string
}

variable "subnet_id" {
  description = "The Subnet ID to launch instances in."
  type        = string
}

variable "name" {
  description = "The name of services"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "The key pair name to use for EC2 instances."
  type        = string
}

