variable "vpc_id" {
  description = "The VPC ID to create resources in."
  type        = string
}

variable "name" {
  description = "The name of services"
  type        = string
}

variable "my_pc_ip" {
  description = "IP to access to EC2 instance"
  type        = string
}
