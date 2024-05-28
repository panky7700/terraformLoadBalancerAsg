# create network here
resource "aws_vpc" "this_vpc" {
    cidr_block = var.network_info.cidr_block # "192.168.0.0/16"
    instance_tenancy = var.network_info.instance_tenancy

    tags = {
      Name = var.network_info.name #"ntier-vpc"
    }
}

# create public subnet
resource "aws_subnet" "this_subnet_private" {
    count = length(var.private_subnets)
    vpc_id     = aws_vpc.this_vpc.id
    cidr_block = var.private_subnets[count.index].cidr_block
    availability_zone =  var.private_subnets[count.index].az
    tags = {
      Name = var.private_subnets[count.index].name
    }  
}

# create internet gateway
resource "aws_internet_gateway" "this_igw" {
    vpc_id     = aws_vpc.this_vpc.id
    tags = {
      Name = var.internet_gateway.name
    }
    depends_on = [ aws_vpc.this_vpc ]  
}

# create public route table 
resource "aws_route_table" "this_public_rt" {
    vpc_id     = aws_vpc.this_vpc.id
    tags = {
        "Name" = "route_table"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.this_igw.id
    }
        depends_on = [
            aws_vpc.this_vpc,
            aws_internet_gateway.this_igw
        ]
      
}

# create public subnet
resource "aws_subnet" "this_subnet_public" {
    count = length(var.public_subnets)
    vpc_id     = aws_vpc.this_vpc.id
    cidr_block = var.public_subnets[count.index].cidr_block
    availability_zone =  var.public_subnets[count.index].az
    tags = {
      Name = var.public_subnets[count.index].name
    }  
}

# associate public subnets with public route table
resource "aws_route_table_association" "this_rt_assoc" {
  count = length(var.public_subnets)
  subnet_id = aws_subnet.this_subnet_public[count.index].id
  route_table_id = aws_route_table.this_public_rt.id
  depends_on = [ 
    aws_subnet.this_subnet_public,
    aws_route_table.this_public_rt
   ]
}