locals {
  common_tags = {
    CreatedBy = "Terraform"
    Group     = "${var.name}-group"
  }
}

# EC2 SSM ROle 생성
resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.name}-ec2_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags,{
    Name = "${var.name}-ec2-ssm-role"
  })
}

# SSM 정책 첨부
resource "aws_iam_role_policy_attachment" "ec2_ssm_policy_attachment" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM 역할 정책 첨부
resource "aws_iam_role_policy_attachment" "attach_list_iam_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = aws_iam_policy.list_iam_policy.arn
}
