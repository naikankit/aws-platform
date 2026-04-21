module "vpc" {
    source = "../modules/VPC"
    vpc_name = var.vpc_name_parent_module
    vpc_cidr_child_module = var.vpc_cidr_parent_module
    public_subnet_cidrs_child_module = var.public_subnet_cidrs_parent_module
    project_name = "main-sg"
    private_subnet_cidrs_child_module = var.private_subnet_cidrs_parent_module
    availability_zones = var.availability_zones_parent_module
    tags = var.tags_parent_module
    aws_region = var.aws_region_parent_module
    
}


output "vpc_id" {
  value = module.vpc.vpc_id
}

module "security_groups" {
  source = "../Modules/security_group"
  security_groups_name = var.security_groups_name
  security_groups_description = var.security_groups_description
  tags = var.tags_parent_module
  ingress_rules = var.ingress_rules
  egress_rules = var.egress_rules
  vpc_id = module.vpc.vpc_id
}

output "security_group_id" {
  value = module.security_groups.security_group_id
}

