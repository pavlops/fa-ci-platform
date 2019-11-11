module "security_group_alb" {
  source = "terraform-aws-modules/security-group/aws"
  version = "3.1.0"

  // Security group parameters
  name = "${local.project_name}-sg-alb"
  description = "Public ALB SG"
  vpc_id = module.vpc.vpc_id
  use_name_prefix = false

  // Access rules
  egress_with_cidr_blocks = [
    {
      rule = "all-tcp"
      cidr_blocks = local.vpc_cidr
      description = "ALL TCP (Internal VPC)"
    }
  ]
  ingress_with_cidr_blocks = [
    {
      rule = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "TCP 80 (Global Access)"
    }
  ]

  // Security group tags
  tags = merge(local.common_tags, {
    "Name" = "${local.project_name}-sg-alb"
  })
}

module "security_group_eks_worker_from_alb" {
  source = "terraform-aws-modules/security-group/aws"
  version = "3.1.0"

  // Security group parameters
  name = "${local.project_name}-sg-eks-worker-from-alb"
  description = "EKS Worker from ALB SG"
  vpc_id = module.vpc.vpc_id
  use_name_prefix = false

  // Access rules
  ingress_with_source_security_group_id = [
    {
      rule = "all-tcp"
      source_security_group_id = module.security_group_alb.this_security_group_id
      description = "ALL TCP (ALB Access)"
    }
  ]

  // Security group tags
  tags = merge(local.common_tags, {
    "Name" = "${local.project_name}-sg-eks-worker-from-alb"
  })
}
