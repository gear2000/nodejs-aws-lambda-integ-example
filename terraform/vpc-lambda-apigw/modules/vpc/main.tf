resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags = {
    Name        = "${var.project}-vpc"
    Project     = "${var.project}"
    managed_by  = "terraform"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name        = "${var.project}-igw"
    Project     = "${var.project}"
    managed_by  = "terraform"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(var.public_subnets_cidr)}"
  cidr_block              = "${element(var.public_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.azs, count.index)}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

  tags = {
    Name        = "${var.project}-public-${count.index}"
    Project     = "${var.project}"
    managed_by  = "terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name        = "${var.project}-public"
    Project     = "${var.project}"
    managed_by  = "terraform"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "private" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(var.private_subnets_cidr)}"
  cidr_block              = "${element(var.private_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.azs, count.index)}"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project}-private-${count.index}"
    Project     = "${var.project}"
    managed_by  = "terraform"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name        = "${var.project}-private"
    Project     = "${var.project}"
    managed_by  = "terraform"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_subnet" "igw" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.igw_cidr}"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project}-igw"
    Project     = "${var.project}"
    managed_by  = "terraform"
  }
}

resource "aws_route_table" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name        = "${var.project}-igw"
    Project     = "${var.project}"
    managed_by  = "terraform"
  }
}

resource "aws_route_table_association" "igw" {
  subnet_id      = "${aws_subnet.igw.id}"
  route_table_id = "${aws_route_table.igw.id}"
}
