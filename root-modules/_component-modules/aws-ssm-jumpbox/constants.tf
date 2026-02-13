locals {
  resource_types = {
    iam_role             = "iam-role"
    iam_policy           = "iam-policy"
    ec2_instance_profile = "ec2-instance-profile"
    ec2_instance         = "ec2-instance"
    ec2_sg               = "ec2-sg"
    dedicated_host       = "dedicated-host"
    ebs                  = "ebs"
    ssm_document         = "ssm-document"
  }
}