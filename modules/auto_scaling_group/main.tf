#create autoscaling group
resource "aws_autoscaling_group" "this_asg"{
    name = var.auto_scale_group.name
    desired_capacity = var.auto_scale_group.desired_capacity
    min_size = var.auto_scale_group.min_size
    max_size = var.auto_scale_group.max_size
    health_check_grace_period = 100
    health_check_type = "EC2"
    force_delete = true
    target_group_arns = [var.auto_scale_group.target_group_arn]
    vpc_zone_identifier = var.auto_scale_group.public_subnets
    
    launch_template {
      id = var.auto_scale_group.launch_template_id
      version = "$Latest"
    }



}