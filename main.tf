provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "cost-test" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.small"   # cheaper than t3.2xlarge
  tags = {
    Environment = "Dev"
    Project     = "Infracost-Test"
    Owner       = "Sudharsanan"
  }
}
