provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  
  force_destroy = true
  # prevent the s3 bucket from deletion while using terraform destroy you can comment it out when you want to destroy it
  # lifecycle {
  #   prevent_destroy = true
  # }
}

# activate versioning for a safety net
resource "aws_s3_bucket_versioning" "bucket_versioning_enabled" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# prevent public access
resource "aws_s3_bucket_public_access_block" "bucket_access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name           = var.dynamodb_table_name
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}

#terraform iam role

#https://spacelift.io/blog/terraform-iam-role

resource "aws_iam_policy" "bucket_policy" {
  name = var.bucket_policy
  path        = "/"
  description = "Allow "
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "s3:ListBucket",
        "Resource": "arn:aws:s3:::${var.bucket_name}"
      },
      {
        "Effect": "Allow",
        "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
        "Resource": "arn:aws:s3:::${var.bucket_name}/${var.key}"
      }
    ]
  })
}

resource "aws_iam_policy" "dynamodb_policy" {
  name = var.dynamodb_policy
  path        = "/"
  description = "Allow "
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ],
        "Resource": "arn:aws:dynamodb:*:*:table/${var.dynamodb_table_name}"
      }
    ]
  })
}

resource "aws_iam_role" "iamrole" {
  name = var.iamrole

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "s3.amazonaws.com"
        }
      },
      
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bucket_policy_attachment" {
  role       = aws_iam_role.iamrole.name
  policy_arn = aws_iam_policy.bucket_policy.arn
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy_attachment" {
  role       = aws_iam_role.iamrole.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # version = "~> 5.43.0"
    }
  }

  # makes no sense to use variables as this is normally used by other people as well.
  # https://www.reddit.com/r/Terraform/comments/1770pbs/pure_string_variable_for_name_of_existing_s3/
  # creating an backend config file
  # https://stackoverflow.com/questions/63048738/how-to-declare-variables-for-s3-backend-in-terraform
  # terraform docs
  # https://developer.hashicorp.com/terraform/language/settings/backends/configuration#partial-configuration
  
  # to make backend work
  # 1. comment this
  # 2. tofu init without backend
  # 3. tofu plan && tofu apply
  # after iamrole, s3 bucket, dynamodb table are created
  # 1. uncomment backend s3
  # 2. tofu init -backend-config=config.s3.tfbackend
  # 3. tofu plan && tofu apply

  # backend "s3" {
  # }
}
