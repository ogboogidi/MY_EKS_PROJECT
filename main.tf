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


module "eks_cluster" {
  source = "./modules/eks_cluster"
  vpc_id = module.vpc.vpc_id
  eks_cluster_name = var.eks_cluster_name
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  backend_subnet_ids = module.vpc.backend_subnet_ids
  eks_cluster_policy_attachment = module.iam.eks_cluster_policy_attachment
  eks_service_policy_attachment = module.iam.eks_service_policy_attachment
}