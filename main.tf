terraform {
  backend "s3" {
    bucket = "hamlet07-test-001"
    key    = "terraform/backend"
    region = "eu-west-1"
  }
}
locals {
  env_name         = "sandbox"
  region           = "eu-west-1"
  k8s_cluster_name = "ms-cluster"
}

# Network Configuration
module "aws_network" {
  source                = "github.com/hamlet07/module-aws-network"
  env_name              = local.env_name
  vpc_name              = "msur-VPC"
  cluster_name          = local.k8s_cluster_name
  aws_region            = local.region
  main_vpc_cidr         = "10.10.0.0/16"
  public_subnet_a_cidr  = "10.10.0.0/18"
  public_subnet_b_cidr  = "10.10.64.0/18"
  private_subnet_a_cidr = "10.10.128.0/18"
  private_subnet_b_cidr = "10.10.192.0/18"
}
# EKS Configuration

# GitOps Configuration