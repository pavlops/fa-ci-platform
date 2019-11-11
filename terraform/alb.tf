module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "4.1.0"

  // ALB parameters
  load_balancer_name = "${local.project_name}-alb"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_groups = [module.security_group_alb.this_security_group_id]
  enable_deletion_protection = false
  logging_enabled = false

  // ALB listeners configuration
  http_tcp_listeners_count = 1
  http_tcp_listeners = [
    {
      "port"               = 80
      "protocol"           = "HTTP"
      "target_group_index" = 0
    }
  ]

  // ALB target group parameters (with the nginx controller backend port)
  target_groups_count = 1
  target_groups = [
    {
      "name"             = "${local.project_name}-tg-eks"
      "backend_protocol" = "HTTP"
      "backend_port"     = 32080
      "slow_start"       = 0
    }
  ]
  target_groups_defaults = {
    cookie_duration                  = 86400
    deregistration_delay             = 300
    health_check_interval            = 10
    health_check_healthy_threshold   = 3
    health_check_path                = "/healthz"
    health_check_port                = "traffic-port"
    health_check_timeout             = 5
    health_check_unhealthy_threshold = 3
    health_check_matcher             = "200-299"
    stickiness_enabled               = true
    target_type                      = "instance"
    slow_start                       = 0
  }

  // ALB tags
  tags = merge(local.common_tags, {
    "Name" = "${local.project_name}-alb"
  })
}
