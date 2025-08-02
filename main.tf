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
# Data source to get the latest Amazon Linux 2023 ARM64 AMI
data "aws_ami" "amazon_linux_2023_arm64" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }
  
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  
  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "foo" {
  ami           = data.aws_ami.amazon_linux_2023_arm64.id
  instance_type = "t4g.micro"
  tags = {
      Name = "TF-Instance"
  }
}