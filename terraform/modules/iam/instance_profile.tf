resource "aws_iam_instance_profile" "ec2_ssm_instance_profile" {
  name = "${var.name}-ec2_ssm_instance_profile"
  role = aws_iam_role.ec2_ssm_role.name

  tags = merge(local.common_tags,{
    Name = "${var.name}-ec2_ssm_instance_profile"
  })
}


