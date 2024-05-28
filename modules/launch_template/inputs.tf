variable "launch_template" {
  type = object({
    name = string
    image_id = string
    instance_type = string
    key_name =string
    sg_ids = string
    associate_public_ip_address = bool
    user_data                   = bool
    user_data_file              = string    
  })

}
