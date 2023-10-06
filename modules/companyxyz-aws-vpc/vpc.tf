resource "aws_vpc" "aws_vpc" {
    cidr_block              = var.vpc_cidr
    enable_dns_hostnames    = true
    enable_dns_support      = true
}

resource "aws_internet_gateway" "aws_igw" {
    vpc_id = aws_vpc.aws_vpc.id
}

resource "aws_subnet" "private" {
    vpc_id                  = aws_vpc.aws_vpc.id
    count                   = length(var.private_subnets)
    cidr_block              = element(var.private_subnets, count.index)
    availability_zone       = element(var.availability_zones, count.index)
    map_public_ip_on_launch = false
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.aws_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gateway.id
    }
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnets)
    subnet_id = element(aws_subnet.private.*.id, count.index)
    route_table_id = aws_route_table.private.id
}

resource "aws_subnet" "public" {
    vpc_id                  = aws_vpc.aws_vpc.id
    count                   = length(var.public_subnets)
    cidr_block              = element(var.public_subnets, count.index)
    availability_zone       = element(var.availability_zones, count.index)
    map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.aws_vpc.id
}

resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_igw.id
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnets)
    subnet_id = element(aws_subnet.public.*.id, count.index)
    route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat_gateway" {
    vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.nat_gateway.id
    subnet_id = element(aws_subnet.public.*.id, 0)
    depends_on = [aws_internet_gateway.aws_igw]
}
