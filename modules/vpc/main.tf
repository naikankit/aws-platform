resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_child_module
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = var.vpc_name
   })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = var.tags
}

resource "aws_eip" "nat_gateway" {
  count = length(var.public_subnet_cidrs_child_module)

  tags = {
    Name = "${var.project_name}-nat-eip-${count.index}"
  }
}

resource "aws_nat_gateway" "main" {
  count         = length(var.public_subnet_cidrs_child_module)
  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.project_name}-nat-gateway-${count.index}"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs_child_module)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs_child_module[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "public-${count.index}"
  })
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs_child_module)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs_child_module[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = merge(var.tags, {
    Name = "private-${count.index}"
  })

}

resource "aws_route_table" "public" {
  vpc_id  = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id 
    }
}

resource "aws_route_table_association" "public" {
  count         = length(var.public_subnet_cidrs_child_module)
  subnet_id     = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidrs_child_module)
  vpc_id  = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id 
    }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs_child_module)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}


resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id
  name   = "${var.project_name}-sg"

  tags = var.tags
}

resource "aws_security_group_rule" "ingress"{
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "outbound"{
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id
  tags = var.tags
  egress {
    rule_no = 100
    protocol = "-1"
    from_port = 0
    to_port = 0
    action = "allow"
    cidr_block = "0.0.0.0/0"
  }

  ingress  {
    rule_no = 100
    protocol = "tcp"
    from_port = 80
    to_port = 80
    action = "allow"
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    rule_no = 110
    protocol = "tcp"
    from_port = 22
    to_port = 22
    action = "allow"
    cidr_block = "0.0.0.0/0"
  }

}

