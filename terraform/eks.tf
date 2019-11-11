module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "6.0.0"

  // EKS master parameters
  cluster_name = "${local.project_name}-eks"
  cluster_version = "1.14"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  // EKS workers parameters
  workers_group_defaults = {
    target_group_arns = concat([
      module.alb.target_group_arns[0]
    ])
    subnets = module.vpc.private_subnets
    public_ip = false
  }
  worker_groups_launch_template = [
    {
      asg_desired_capacity = 1
      asg_max_size = 1
      asg_min_size = 1
      on_demand_base_capacity = 0
      on_demand_percentage_above_base_capacity = 0
      autoscaling_enabled = false
      protect_from_scale_in = false
      root_volume_size = 10
      instance_type = "t3.xlarge"
    }
  ]
  worker_additional_security_group_ids = [
    module.security_group_eks_worker_from_alb.this_security_group_id
  ]
  workers_additional_policies = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  ]

  // Kubeconfig parameters
  map_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/pablo.suarez"
      username = "pablo.suarez"
      groups   = ["system:masters"]
    }
  ]
  write_kubeconfig = "false"
  write_aws_auth_config = "false"

  // EKS Tags
  tags = merge(local.common_tags, {
    "Name" = "${local.project_name}-eks"
  })
}

resource "helm_release" "nginx_ingress" {
  //depends_on = [module.eks]

  // Installation of the nginx ingress controller into the EKS cluster
  name          = "nginx-ingress"
  chart         = "stable/nginx-ingress"
  version       = "1.24.1"
  namespace     = "kube-system"
  force_update  = true

  values = [
    "${file("../helm/nginx_controller.yaml")}"
  ]
}
