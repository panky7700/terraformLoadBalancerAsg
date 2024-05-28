module "vpc" {
  source = "./modules/vpc"
  network_info = {
    name             = "testDemovpc"
    cidr_block       = "192.168.0.0/16"
    instance_tenancy = "default"
  }
  public_subnets = [{
    name       = "web01"
    az         = "us-east-1a"
    cidr_block = "192.168.1.0/24"
    },
    {
      name       = "web02"
      az         = "us-east-1b"
      cidr_block = "192.168.2.0/24"
  }]

  private_subnets = [{
    name       = "db01"
    az         = "us-east-1a"
    cidr_block = "192.168.3.0/24"
    },
    {
      name       = "db02"
      az         = "us-east-1b"
      cidr_block = "192.168.4.0/24"
  }]
  internet_gateway = {
    name = "testDemoigw"
  }

}

#create security group
module "testDemosgASG" {
  source = "./modules/security_group"
  security_group_info = {


    name        = "testDemoautoScalingGroup"
    description = "This is used for asg"
    vpc_id      = module.vpc.vpcid

    inbound_rules = [{
      cidr_block  = local.any_ipv4
      port        = local.http
      protocol    = local.tcp
      description = "openhttp"
      },
      {
        cidr_block  = local.any_ipv4
        port        = local.ssh
        protocol    = local.tcp
        description = "openhttp"
      }
    ]

    outbound_rules = [{
      cidr_block  = local.any_ipv4
      from_port   = local.http
      protocol    = local.tcp
      description = "out all"
      to_port     = local.http
    }]
    allow_all_egress = true

  }
  depends_on = [module.vpc]
}

module "testDemosgLB" {
  source = "./modules/security_group"
  security_group_info = {


    name        = "testDemoLoadBalancer"
    description = "This is used for lb"
    vpc_id      = module.vpc.vpcid

    inbound_rules = [{
      cidr_block  = local.any_ipv4
      port        = local.http
      protocol    = local.tcp
      description = "openhttp"
      },
      {
        cidr_block  = local.any_ipv4
        port        = local.ssh
        protocol    = local.tcp
        description = "openhttp"
      }
    ]

    outbound_rules = [{
      cidr_block  = local.any_ipv4
      from_port   = local.http
      protocol    = local.tcp
      description = "out all"
      to_port     = local.http
    }]
    allow_all_egress = true

  }
  depends_on = [module.vpc]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

module "testDemoTemplate" {
  source = "./modules/launch_template"
  launch_template = {
    name                        = "testDemoTemplate01"
    image_id                    = data.aws_ami.ubuntu.id
    instance_type               = "t2.micro"
    key_name                    = "DemoAwsSecretkey"
    sg_ids                      = module.testDemosgASG.security_group_id
    associate_public_ip_address = true
    user_data                   = true
    user_data_file              = "install.sh"
  }
  depends_on = [module.vpc]
}
module "testDemoLB" {
  source = "./modules/load_balancer"
  alb_values = {
    lb_name            = "testDemoLB01"
    load_balancer_type = "application"
    internal           = false
    security_group_id  = module.testDemosgLB.security_group_id
    subnets            = module.vpc.public_subnets
    from_port          = 80
    to_port            = 80
    protocol           = "HTTP"
    default_action     = "forward"
    vpc_id             = module.vpc.vpcid
  }
  depends_on = [module.vpc]

}
module "testDemoASG" {
  source = "./modules/auto_scaling_group"
  auto_scale_group = {
    name               = "testDemoautoScalingGroup"
    desired_capacity   = 2
    min_size           = 2
    max_size           = 3
    public_subnets     = module.vpc.public_subnets
    launch_template_id = module.testDemoTemplate.launch_template_id
    target_group_arn   = module.testDemoLB.target_grp_arn

  }
  depends_on = [ 
    module.testDemoLB ,
    module.testDemoTemplate
  ]
}

