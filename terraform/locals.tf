data "aws_caller_identity" "current" {}

locals {
  project_name = "fa"

  vpc_cidr = "10.50.0.0/16"
  vpc_subnet_private_cidrs = ["10.50.4.0/22", "10.50.8.0/22", "10.50.12.0/22"]
  vpc_subnet_public_cidrs = ["10.50.16.0/22", "10.50.20.0/22", "10.50.24.0/22"]
  aws_region = "eu-west-1"
  aws_region_azs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

  common_tags = {
    Project = local.project_name
    Region = "eu-west-1"
  }
}
