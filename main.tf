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
# Simple S3 bucket for testing
resource "aws_s3_bucket" "test_bucket" {
  bucket = "terraform-test-bucket-${random_id.bucket_suffix.hex}"
  tags = {
    Name = "TF-Test"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_instance" "test_instance" {
  ami           = "ami-0387d929287ab193e"
  instance_type = "t3.micro"

  tags = {
    Name        = "TF-Test"
  }
}
