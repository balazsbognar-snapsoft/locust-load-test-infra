resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = "IMMUTABLE"
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_master_key_id
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = module.label_aws_ecr_repository.tags
}

data "aws_iam_policy_document" "repository_policy" {
  statement {
    sid    = "InternalECRRepositoryReadAccess"
    effect = "Allow"
    principals {
      identifiers = [for account in var.account_ids : "arn:aws:iam::${account}:root"]
      type        = "AWS"
    }
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings",
    ]
  }

  statement {
    sid    = "ExternalECRRepositoryWriteAccess"
    effect = "Allow"
    principals {
      identifiers = var.trusted_principle_arns
      type        = "AWS"
    }
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
  }
}

resource "aws_ecr_repository_policy" "ecr_access" {
  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.repository_policy.json
}
