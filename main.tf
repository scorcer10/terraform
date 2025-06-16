provider "aws" {
    region = "us-west-2"  
}

resource "aws_instance" "foo" {
  ami           = "ami-0779fe5e56472b841"  # Amazon Linux 2023 (ARM)
  instance_type = "t4g.micro"
  tags = {
      Name = "TF-Instance"
  }
}