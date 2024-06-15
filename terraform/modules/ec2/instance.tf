locals {
  common_tags = {
    CreatedBy = "Terraform"
    Group     = "${var.name}-group"
  }
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids  = [var.security_group_id]
  iam_instance_profile  = var.instance_profile_role

  root_block_device {
    volume_type = "gp3"  # 볼륨 유형을 gp3로 설정
    volume_size = 30     # 볼륨 크기를 30GB로 설정
  }

  user_data = <<-EOF
              #!/bin/bash
              # Update and install necessary packages
              sudo yum update -y
              sudo yum install -y curl wget apt-transport-https gnupg2

              # Create a new user 'msinsa'
              sudo groupadd docker
              sudo groupadd msinsa
              sudo useradd msinsa -m -d /home/msinsa -g msinsa -G docker
              echo 'msinsa ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/msinsa

              # Switch to user 'msinsa' for further installation
              sudo su - msinsa -c '
              # Install Docker
              sudo yum install docker -y
              sudo systemctl start docker
              sudo systemctl enable docker

              # Install conntrack
              sudo yum install -y conntrack

              # Install Minikube
              curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
              chmod +x minikube
              sudo mv minikube /usr/local/bin/

              # Install kubectl
              curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
              chmod +x kubectl
              sudo mv kubectl /usr/local/bin/

              EOF

  tags = merge(local.common_tags,{
    Name = "${var.name}-ec2"
  })
}
