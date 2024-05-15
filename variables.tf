variable "region" {
  description = "The AWS region where the resources will be provisioned."
}

variable "instance_type" {
  description = "The type of EC2 instance to launch."
}

variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 instance."
}

variable "instance_name" {
  description = "The name of the EC2 instance."
}

variable "allow_all_inbound" {
  description = "Whether to allow all inbound traffic."
}
