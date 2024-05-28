output "vpcid" {
    value = aws_vpc.this_vpc.id  
}

output "public_subnets"{
    value = aws_subnet.this_subnet_public.*.id 
}

output "private_subnets" {
    value = aws_subnet.this_subnet_private.*.id 
}

output "igw" {
    value = aws_internet_gateway.this_igw.id  
}