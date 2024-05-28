resource "aws_security_group" "this_sg" {
    name= var.security_group_info.name
    description = var.security_group_info.description
    vpc_id= var.security_group_info.vpc_id
 tags = {
   "Name" = var.security_group_info.name
 }
  
}

# incoming traffic rules
resource "aws_vpc_security_group_ingress_rule" "this_ingress" {
    count = length(var.security_group_info.inbound_rules)
    security_group_id = aws_security_group.this_sg.id
    cidr_ipv4 = var.security_group_info.inbound_rules[count.index].cidr_block
    from_port = var.security_group_info.inbound_rules[count.index].port
    to_port = var.security_group_info.inbound_rules[count.index].port
    ip_protocol = var.security_group_info.inbound_rules[count.index].protocol
    description = var.security_group_info.inbound_rules[count.index].description

    depends_on = [ aws_security_group.this_sg ]  
}

#outgoing traffic rules
resource "aws_vpc_security_group_egress_rule" "this_egress" {
    count = length(var.security_group_info.outbound_rules)
    security_group_id = aws_security_group.this_sg.id
    cidr_ipv4 = var.security_group_info.outbound_rules[count.index].cidr_block
    from_port = var.security_group_info.outbound_rules[count.index].from_port
    to_port = var.security_group_info.outbound_rules[count.index].to_port
    ip_protocol = var.security_group_info.outbound_rules[count.index].protocol
    description = var.security_group_info.outbound_rules[count.index].description

    depends_on = [ aws_security_group.this_sg ]  
}

resource "aws_vpc_security_group_egress_rule" "this_all_egress" {
    count = var.security_group_info.allow_all_egress ? 1 : 0
    security_group_id = aws_security_group.this_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
    description = "This will allow all tcp traffic"
    depends_on = [ aws_security_group.this_sg ]  
}
