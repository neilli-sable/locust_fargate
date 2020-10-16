# VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.general_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.general_name
  }
}

# Subnets
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = var.general_name
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "${var.region}c"

  tags = {
    Name = var.general_name
  }
}

# Routes Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = var.general_name
  }
}

resource "aws_route_table_association" "route_table_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "route_table_c" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.public_route_table.id
}

# Service Discovery
resource "aws_service_discovery_private_dns_namespace" "locust_internal" {
  name        = "locust.internal"
  description = var.general_name
  vpc         = aws_vpc.vpc.id
}

resource "aws_service_discovery_service" "master" {
  name = "master"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.locust_internal.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
