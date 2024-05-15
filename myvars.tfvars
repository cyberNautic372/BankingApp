variable "region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-0f58b397bc5c1f2e8"
}

variable "instance_name" {
  default = "test-server"
}

variable "allow_all_inbound" {
  default = true
}
