output "target_grp_arn" {
  value =  aws_lb_target_group.Lb_ec2_tg.arn
}

output "lb_dns_name" {
    value = aws_lb.testDemoAppLb.dns_name
  
}