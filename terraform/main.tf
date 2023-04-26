resource "aws_ecr_repository" "MY-ECR" {
  name                 = "app-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_vpc" "myVOIP" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "subzero" {
  vpc_id     = aws_vpc.myVOIP.id
  cidr_block = var.cidr_subzero_1 
map_public_ip_on_launch = true
availability_zone = var.subnet12_az
  tags = {
    Name = "subzero"
  }
}

resource "aws_subnet" "subone" {
  vpc_id     = aws_vpc.myVOIP.id
  cidr_block = var.cidr_subone_2 
  map_public_ip_on_launch = true
  availability_zone = var.subnet13_az

  tags = {
    Name = "subone"
  }
}

resource "aws_subnet" "subtwo" {
  vpc_id     = aws_vpc.myVOIP.id
  cidr_block = var.cidr_subtwo_3
  availability_zone = var.subnet14_az

  tags = {
    Name = "subtwo"
  }
}

resource "aws_subnet" "subthree" {
  vpc_id     = aws_vpc.myVOIP.id
  cidr_block = var.cidr_subthree_4 
  availability_zone = var.subnet15_az

  tags = {
    Name = "subthree"
  }
}

resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.myVOIP.id

  tags = {
    Name = "prod-igw"
  }
}

resource "aws_route_table" "prod-pub-rt" {
  vpc_id = aws_vpc.myVOIP.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod-igw.id
  }

  tags = {
    Name = "prod-pub-rt"
  }
}

resource "aws_route_table" "prod-priv-rt" {
  vpc_id = aws_vpc.myVOIP.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.chuckskin.id
  }

  tags = {
    Name = "prod-pub-rt"
  }
}

resource "aws_eip" "ezp" {
  vpc = true
  tags = {
   Name = "demarko"
  }
}

resource "aws_route_table_association" "rt-association-pub1" {
  subnet_id      = aws_subnet.subzero.id
  route_table_id = aws_route_table.prod-pub-rt.id
}

resource "aws_route_table_association" "rt-association-pub2" {
  subnet_id      = aws_subnet.subone.id
  route_table_id = aws_route_table.prod-pub-rt.id
}

resource "aws_route_table_association" "rt-association-priv3" {
  subnet_id      = aws_subnet.subtwo.id
  route_table_id = aws_route_table.prod-priv-rt.id
}

resource "aws_route_table_association" "rt-association-priv4" {
  subnet_id      = aws_subnet.subthree.id
  route_table_id = aws_route_table.prod-priv-rt.id
}

resource "aws_nat_gateway" "chuckskin" {
  allocation_id = aws_eip.ezp.id
  subnet_id     = aws_subnet.subzero.id

  tags = {
    Name = "demarko-nat"
  }
}
#  
#

