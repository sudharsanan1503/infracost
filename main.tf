############################
# Provider
############################
provider "aws" {
  region = "us-east-1"
}

############################
# Default / Common Tags
############################
locals {
  common_tags = {
    Project     = "Infracost-Demo"
    Environment = "Dev"
    Service     = "demo-app"
    Owner       = "Sudharsanan"
    ManagedBy   = "Terraform"
  }
}

############################
# EC2 Instance
############################
resource "aws_instance" "demo_ec2" {
  ami                         = "ami-0f5ee92e2d63afc18"
  instance_type               = "t3.small"
  associate_public_ip_address = false

  tags = merge(
    local.common_tags,
    {
      Name = "demo-ec2"
    }
  )
}

############################
# S3 Bucket - Application
############################
resource "aws_s3_bucket" "app_bucket" {
  bucket        = "infracost-demo-app-sudharsanan"
  force_destroy = true
  tags          = local.common_tags
}

############################
# S3 Bucket - Logs
############################
resource "aws_s3_bucket" "log_bucket" {
  bucket        = "infracost-demo-logs-sudharsanan"
  force_destroy = true
  tags          = local.common_tags
}

############################
# S3 Access Logging
############################
resource "aws_s3_bucket_logging" "app_bucket_logging" {
  bucket        = aws_s3_bucket.app_bucket.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "access-logs/"
}

############################
# S3 Lifecycle - App Bucket
############################
resource "aws_s3_bucket_lifecycle_configuration" "app_bucket_lifecycle" {
  bucket = aws_s3_bucket.app_bucket.id

  rule {
    id     = "abort-incomplete-multipart"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

############################
# S3 Lifecycle - Log Bucket
############################
resource "aws_s3_bucket_lifecycle_configuration" "log_bucket_lifecycle" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    id     = "abort-incomplete-multipart"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

############################
# CloudWatch Log Group
############################
resource "aws_cloudwatch_log_group" "demo_logs" {
  name              = "/infracost/demo/app"
  retention_in_days = 7
  tags              = local.common_tags
}
