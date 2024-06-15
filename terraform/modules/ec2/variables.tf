variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "ap-northeast-2"
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

variable "instance_profile_role" {
  description = "The instance profile role for EC2 instances."
  type        = string
}

variable "security_group_id" {
  description = "The security_group id."
  type        = string
}
