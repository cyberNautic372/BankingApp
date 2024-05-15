provider "aws" {
  region = var.region  # Mumbai region
}

resource "aws_instance" "test_server" {
  ami           = var.ami_id  # Replace with your desired AMI ID
  instance_type = var.instance_type
  key_name      = "masterkey"  # Use existing keypair
  tags = {
    Name = var.instance_name  # Changed instance name to "test-server"
  }

  # Allow all inbound traffic from anywhere
  security_groups = ["allow-all-inbound"]

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname testserver"
    ]
  }
}

resource "aws_security_group" "allow-all-inbound" {
  name        = "allow-all-inbound"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to anywhere
  }
}
