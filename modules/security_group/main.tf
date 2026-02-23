resource "aws_security_group" "web_custom" {
  
  name = var.security_groups_name
  description = var.security_groups_description
  tags = merge(var.tags, { Name = var.security_groups_name })
  vpc_id = var.vpc_id
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      
      description = egress.value.description
      from_port =  egress.value.from_port
      to_port = egress.value.to_port
      protocol = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port =  ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}