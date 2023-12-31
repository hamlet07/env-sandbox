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
module "aws_eks" {
  source                = "github.com/hamlet07/module-aws-kubernetes"
  env_name              = local.env_name
  cluster_name          = local.k8s_cluster_name
  aws_region            = local.region
  vpc_id                = module.aws_network.vpc_id
  cluster_subnet_ids    = module.aws_network.subnet_ids

  nodegroup_subnet_ids       = module.aws_network.private_subnet_ids
  nodegroup_disk_size        = "20"
  nodegroup_instance_types    = ["t3.medium"]
  nodegroup_desired_size = 1
  nodegroup_min_size         = 1
  nodegroup_max_size         = 3
}

# GitOps Configuration
module "argo-cd-server" {
  source = "github.com/hamlet07/module-argo-cd.git"
  kubernetes_cluster_id = module.aws_eks.eks_cluster_id
  kubernetes_cluster_name = module.aws_eks.eks_cluster_name
  kubernetes_cluster_cert_data = module.aws_eks.eks_cluster_certificate_data
  kubernetes_cluster_endpoint = module.aws_eks.eks_cluster_endpoint
  eks_nodegroup_id = module.aws_eks.eks_cluster_nodegroup_id
}