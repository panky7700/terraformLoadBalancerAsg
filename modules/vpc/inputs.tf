variable "network_info" {
    type = object({
      name = string
      cidr_block = string
      instance_tenancy = string
    })
    description = "Define network vpc"
}

variable "public_subnets" {
 type = list(object({
   name = string
   cidr_block = string
   az = string
 })) 
 description = "Define public subnet"
}

variable "internet_gateway" {
    type = object({
      name = string
    })
  description = "Define internet gateway to connect other network"
}

variable "private_subnets" {
 type = list(object({
   name = string
   cidr_block = string
   az = string
 }))
 description = "Define private subnet"
}