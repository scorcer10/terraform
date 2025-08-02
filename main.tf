terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}
resource "aws_instance" "foo" {
  ami           = "ami-0387d929287ab193e"  # Amazon Linux 2023 (x86_64) - us-west-2 
  instance_type = "t3.micro"
  tags = {
      Name = "TF-Instance"
  }
}