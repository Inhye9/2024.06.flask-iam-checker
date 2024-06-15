locals {
  common_tags = {
    CreatedBy = "Terraform"
    Group     = "${var.name}-group"
  }
}

resource "aws_security_group" "sg" {
  name        = "${var.name}-sg"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id

  # ssh port
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_pc_ip}/32"]   #로컬 PC IP
  }

  # docker run test port
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # minikube proxy port
  ingress {
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags,{
    Name = "${var.name}-sg"
  })
}
