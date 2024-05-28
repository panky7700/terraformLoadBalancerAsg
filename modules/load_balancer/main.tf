# Create Application Load Balancer
resource "aws_lb" "testDemoAppLb" {
    name= var.alb_values.lb_name
    load_balancer_type = var.alb_values.load_balancer_type
    internal = var.alb_values.internal
    security_groups = [ var.alb_values.security_group_id ] # security groups
    subnets = var.alb_values.subnets # subnet is list of string
    # depends_on = [var.alb_values.internet_gateway ] # internet gateway
}

resource "aws_lb_target_group" "Lb_ec2_tg" {
    name = "${var.alb_values.lb_name}Tg"
    port = var.alb_values.from_port
    protocol = var.alb_values.protocol
    vpc_id =  var.alb_values.vpc_id #define aws vpc id
    tags = {
        Name= "${var.alb_values.lb_name}Tg_ec2"
    }
  
}

resource "aws_lb_listener" "Lb_ec2_ls" {
    load_balancer_arn = aws_lb.testDemoAppLb.arn
    port = var.alb_values.to_port
    protocol = var.alb_values.protocol
    default_action {
      type= var.alb_values.default_action
      target_group_arn = aws_lb_target_group.Lb_ec2_tg.arn      
    }

    tags = {
      Name =  "${var.alb_values.lb_name}Li_ec2"
    }
}

