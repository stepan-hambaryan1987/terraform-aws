# VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.project
  }
}

# Internet Gateway for public egress
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.internet_gateway
  }
}

# Elastic IP
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = var.el_ip
  }
}

# --- Subnets ---

# Public subnets
resource "aws_subnet" "public" {
  for_each = { for idx, az in var.azs : tostring(idx) => az }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[tonumber(each.key)]
  availability_zone       = each.value
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public-${each.key}"
  }
}


# Private subnets 
resource "aws_subnet" "private" {
  for_each = { for idx, az in var.azs : tostring(idx) => az }

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[tonumber(each.key)]
  availability_zone = each.value

  tags = {
    Name = "${var.project}-private-${each.key}"
  }
}

# NAT Gateway placed in the first public subnet (index 0)
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["0"].id

  tags = {
    Name = "${var.project}-nat"
  }

  depends_on = [aws_internet_gateway.this]
}



# Public route table (0.0.0.0/0 -> IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project}-public-rt"

  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private route table (0.0.0.0/0 -> NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project}-private-rt"
  }
}

resource "aws_route" "private_egress" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}