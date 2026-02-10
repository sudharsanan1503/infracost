provider "aws" {
  region = "us-east-1"
}

locals {
  tags = {
    Project     = "Infracost-Demo"
    Environment = "test"
    Owner       = "Sudharsanan"
  }
}

resource "aws_instance" "demo" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  tags = local.tags
}

resource "aws_s3_bucket" "app" {
  bucket        = "infracost-demo-app-sudharsanan"
  force_destroy = true
  tags          = local.tags
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/infracost/demo"
  retention_in_days = 7
  tags              = local.tags
}
