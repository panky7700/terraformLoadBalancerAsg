variable "auto_scale_group"{
    type=object({
      name = string
      desired_capacity = number
      min_size = number
      max_size = number
      public_subnets = list(string)
      launch_template_id = string
      target_group_arn = string
    })
}
