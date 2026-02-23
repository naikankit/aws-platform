variable "ingress_rules" {
  type = map(object({
    description  = string
    from_port = number
    to_port = number
    cidr_blocks = list(string)
    protocol = string
  }))
  default = {
  }
}

variable "vpc_id" {
  type = string
}

variable "egress_rules" {
  type = map(object({
    description  = string
    from_port = number
    to_port = number
    cidr_blocks = list(string)
    protocol = string
  }))
  default = {
    "egress_rule_default" = {
     description = "default egress rule"
     from_port = 0
     to_port = 0
     cidr_blocks = ["0.0.0.0/0"]
     protocol = "-1"
    }
  }
}

variable "security_groups_name" {
    type =  string
}

variable "tags" {
  type = map(string)
}

variable "security_groups_description" {
  type = string
}


