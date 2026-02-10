provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "cost-test" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  tags = {
    Environment = "Dev"
    Project     = "Infracost-Test"
    Owner       = "Sudharsanan"
  }
}
