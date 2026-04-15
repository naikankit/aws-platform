vpc_cidr_parent_module = "10.0.0.0/16"

public_subnet_cidrs_parent_module = ["10.0.0.0/24", "10.0.1.0/24"]

private_subnet_cidrs_parent_module = ["10.0.2.0/24", "10.0.3.0/24"]

availability_zones_parent_module = ["us-east-1a", "us-east-1b", "us-east-1c"]

tags = {
  Environment = "Dev"
  Project     = "Demo"
}

tags_parent_module = {
  Environment = "Dev"
  Project     = "Demo"
}


ingress_rules = {
  "ingress_rule_1" = {
    description = "Allow HTTP traffic"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
  }
  "ingress_rule_2" = {
    description = "Allow HTTPS traffic"
    from_port = 443
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
  }
}

egress_rules = {
  "egress_rule_1" = {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
  }
} 