variable "alb_values" {
  type = object({
    lb_name = string
    load_balancer_type = string
    internal = bool
    security_group_id = string
    subnets = list(string)
    from_port = number
    to_port= number
    protocol = string
    default_action = string
    vpc_id = string
  })

}