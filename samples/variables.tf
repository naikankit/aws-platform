variable "aws_region_parent_module" {
  type    = string
  default = "us-east-1"
}

variable "vpc_name_parent_module" {
  type    = string
  default = "my-vpc"
}

variable "tags_parent_module" {
  type = map(string)
}

variable "vpc_cidr_parent_module" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs_parent_module" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs_parent_module" {
  type = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "availability_zones_parent_module" {
  type = list(string)
}

variable "tags" {   
  description = "A map of tags to apply to all resources"
  type        = map(string)
  
}

variable "security_groups_name" {
  type    = string
  default = "my-security-group"
}

variable "security_groups_description" {
  type    = string
  default = "My security group"
} 

variable "ingress_rules" {
 description = "A map of ingress rules for the security group"
 type = map(object({
   description = string
   from_port = number
   to_port = number
   cidr_blocks = list(string)
   protocol = string
 }))
 default = {
 }
}

variable "egress_rules" {
 description = "A map of egress rules for the security group"
 type = map(object({
   description = string
   from_port = number
   to_port = number
   cidr_blocks = list(string)
   protocol = string
 }))
 default = {
 }
}