module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.15.0"

  // VPC parameters
  name = "${local.project_name}-vpc"

  // CIDR VPC ranges and zones
  cidr = local.vpc_cidr
  private_subnets = local.vpc_subnet_private_cidrs
  public_subnets = local.vpc_subnet_public_cidrs
  azs = local.aws_region_azs

  // Networking configuration
  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = false
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  // Tagging of VPC resources
  tags = local.common_tags
  vpc_tags = { Name = "${local.project_name}-vpc" }
  private_subnet_tags = { Name = "${local.project_name}-vpc-subnet-private" }
  public_subnet_tags = { Name = "${local.project_name}-vpc-subnet-public" }
  private_route_table_tags = { Name = "${local.project_name}-vpc-rt-private" }
  public_route_table_tags = { Name = "${local.project_name}-vpc-rt-public" }
  igw_tags = { Name = "${local.project_name}-vpc-igw" }
  nat_gateway_tags = { Name = "${local.project_name}-vpc-nat" }
  nat_eip_tags = { Name = "${local.project_name}-vpc-nat-eip" }
}
