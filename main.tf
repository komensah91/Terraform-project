resource "aws_vpc" "Tenacity-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Tenacity-vpc"
  }
}

# public subnet 1
resource "aws_subnet" "Prod-pub-sub1" {
   vpc_id     = aws_vpc.Tenacity-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Prod-pub-sub1"
  }
}

# public subnet 2
resource "aws_subnet" "Prod-pub-sub2" {
   vpc_id     = aws_vpc.Tenacity-vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "Prod-pub-sub2"
  }
}

# private subnet 1
resource "aws_subnet" "Prod-priv-sub1" {
   vpc_id     = aws_vpc.Tenacity-vpc.id
  cidr_block = "10.0.3.0/24"
  tags = {
    Name = "Prod-priv-sub1"
  }
}

# Private subnet 2

resource "aws_subnet" "Prod-priv-sub2" {
   vpc_id     = aws_vpc.Tenacity-vpc.id
  cidr_block = "10.0.4.0/24"
  tags = {
    Name = "Prod-priv-sub2"
  }
}

# public route table
resource "aws_route_table" "Prod-pub-route-table" {
  vpc_id = aws_vpc.Tenacity-vpc.id


  tags = {
    Name = "Prod-pub-route-table"
  }
}


# private route table
resource "aws_route_table" "Prod-priv-route-table" {
  vpc_id = aws_vpc.Tenacity-vpc.id


  tags = {
    Name = "Prod-priv-route-table"
  }
}

# public route table association 1
resource "aws_route_table_association" "public-route1" {
  subnet_id = aws_subnet.Prod-pub-sub1.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}

# public route table association 2
resource "aws_route_table_association" "public-route2" {
  subnet_id = aws_subnet.Prod-pub-sub2.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}

# private route table association 1
resource "aws_route_table_association" "priv-route1" {
  subnet_id = aws_subnet.Prod-priv-sub1.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}


# private route table association 2
resource "aws_route_table_association" "priv-route2" {
  subnet_id = aws_subnet.Prod-priv-sub2.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}


# internet gateway
resource "aws_internet_gateway" "Prod-igw" {
  vpc_id = aws_vpc.Tenacity-vpc.id

  tags = {
    Name = "Prod-igw"
  }
}

# elastic IP 

resource "aws_eip" "Prod-eip" {
  domain = "vpc"
}


#nat gateway
resource "aws_nat_gateway" "Prod_ngw" {
  allocation_id = aws_eip.Prod-eip.id
  subnet_id = aws_subnet.Prod-pub-sub1.id
  

  tags = {
    Name = "Prod_ngw"
  }
}

# internet gateway Association
resource "aws_route" "Prod-igw-route" {
route_table_id = aws_route_table.Prod-pub-route-table.id
gateway_id = aws_internet_gateway.Prod-igw.id
destination_cidr_block = "0.0.0.0/0"
  
}

#nat gateway Association
resource "aws_route" "Prod-ngw" {
  route_table_id = aws_route_table.Prod-priv-route-table.id
  nat_gateway_id = aws_nat_gateway.Prod_ngw.id
  destination_cidr_block = "0.0.0.0/0"
}