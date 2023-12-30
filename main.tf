terraform {
  backend "s3" {
    bucket = "hamlet07-test-001"
    key    = "terraform/backend"
    region = "eu-west-1"
  }
}
locals {
  env_name = "sandbox"
  region = "eu-west-1"
  k8s_cluster_name = "ms-cluster"
}

# Network Configuration

# EKS Configuration

# GitOps Configuration