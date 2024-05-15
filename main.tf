provider "aws" {
  region = var.region
}

resource "aws_instance" "test_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = "masterkey"  # Use the existing key pair named "masterkey"
  tags = {
    Name = "test-server"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname testserver"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Adjust if the username is different
      private_key = file("${path.module}/masterkey.pem")  # Reference the masterkey.pem file in the root directory
      host        = self.public_ip  # Use the public IP of the instance
    }
  }

  # Ensure the security group is created before referencing it
  depends_on = [aws_security_group.allow-all-inbound]

  # Allow all inbound traffic from anywhere if required
  count = var.allow_all_inbound ? 1 : 0

  security_groups = var.allow_all_inbound ? [aws_security_group.allow-all-inbound[count.index].name] : []

  vpc_security_group_ids = [ "sg-02d6d82fdca28cd20" ]  # Add the existing security group ID here
  vpc_id                 = "vpc-08d25340e2af1d08e"      # Add the existing VPC ID here
}

resource "aws_security_group" "allow-all-inbound" {
  count        = var.allow_all_inbound ? 1 : 0
  name        = "allow-all-inbound-${random_string.random_suffix[count.index].result}"
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

resource "random_string" "random_suffix" {
  count           = var.allow_all_inbound ? 1 : 0
  length          = 6
  special         = false
  upper           = false
  numeric         = true  # Use `numeric` instead of `number`
  override_special = "_%@"
}
