variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id" {
  type    = string
  default = "ami-0f58b397bc5c1f2e8"
}

variable "instance_name" {
  type    = string
  default = "test-server"
}

variable "allow_all_inbound" {
  type    = bool
  default = true
}

