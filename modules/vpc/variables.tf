variable "vpc_cidr_child_module" {
  type = string
}

variable "vpc_name" {
  type = string
}
variable "public_subnet_cidrs_child_module" {
  type = list(string)
}

variable "private_subnet_cidrs_child_module" {
  type = list(string)
}

variable "project_name" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "aws_region" {
  type = string
}