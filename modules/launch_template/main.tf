#create launch template 
resource "aws_launch_template" "this_template" {
    
    name = var.launch_template.name
    image_id = var.launch_template.image_id
    instance_type = var.launch_template.instance_type
    key_name = var.launch_template.key_name
    network_interfaces {
        associate_public_ip_address = var.launch_template.associate_public_ip_address
        ## import step include secutiry group
        security_groups = [ var.launch_template.sg_ids ]
    }
    # vpc_security_group_ids = [
    #     var.launch_template.sg_ids
    # ]
    tags = {
        Name= var.launch_template.name
    }
    #user_data = filebase64("${path.module}/install.sh")
    user_data = var.launch_template.user_data ? filebase64(var.launch_template.user_data_file) : ""
    
}