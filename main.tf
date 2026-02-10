provider "aws" {
  region = "us-east-1"
}

locals {
  common_tags = {
    Project     = "Infracost-Demo"
    Environment = "test"
    Owner       = "Sudharsanan"
    ManagedBy   = "Terraform"
  }
}

resource "aws_instance" "demo_ec2" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t3.micro"   # BASELINE (cheap)

  tags = merge(local.common_tags, {
    Name = "demo-ec2"
  })
}

resource "aws_s3_bucket" "app_bucket" {
  bucket        = "infracost-demo-app-sudharsanan"
  force_destroy = true
  tags          = local.common_tags
}

resource "aws_s3_bucket" "log_bucket" {
  bucket        = "infracost-demo-logs-sudharsanan"
  force_destroy = true
  tags          = local.common_tags
}

resource "aws_s3_bucket_logging" "app_bucket_logging" {
  bucket        = aws_s3_bucket.app_bucket.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "access-logs/"
}

resource "aws_cloudwatch_log_group" "demo_logs" {
  name              = "/infracost/demo/app"
  retention_in_days = 7
  tags              = local.common_tags
}
