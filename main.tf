provider "aws" {
  region = "us-east-1"
}







module "vpc" {
  source                      = "./modules/vpc"
  tags                        = local.eks_tags
  vpc_cidr_block              = var.vpc_cidr_block
  availability_zone           = var.availability_zone
  frontend_subnets_cidr_block = var.frontend_subnets_cidr_block
  backend_subnets_cidr_block  = var.backend_subnets_cidr_block
}


module "iam" {
  source = "./modules/iam"
  eks_cluster_name = var.eks_cluster_name
}