provider "aws" {
  region = "us-east-1"
}



data "aws_eks_cluster_auth" "my_eks_cluster_auth" {
  name = module.eks_cluster.eks_cluster_name
}


provider "kubernetes" {
  host                   = module.eks_cluster.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_cluster.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.my_eks_cluster_auth.token
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
  source           = "./modules/iam"
  eks_cluster_name = var.eks_cluster_name
}


module "eks_cluster" {
  source                        = "./modules/eks_cluster"
  vpc_id                        = module.vpc.vpc_id
  eks_cluster_name              = var.eks_cluster_name
  eks_cluster_role_arn          = module.iam.eks_cluster_role_arn
  backend_subnet_ids            = module.vpc.backend_subnet_ids
  eks_cluster_policy_attachment = module.iam.eks_cluster_policy_attachment
  eks_service_policy_attachment = module.iam.eks_service_policy_attachment
}



module "eks_workers_node" {
  source                   = "./modules/eks_worker_node"
  vpc_id                   = module.vpc.vpc_id
  vpc_cidr_block           = var.vpc_cidr_block
  eks_cluster_name         = var.eks_cluster_name
  eks_cluster_endpoint     = module.eks_cluster.eks_cluster_endpoint
  image_id                 = var.image_id
  key_name                 = var.key_name
  instance_type            = var.instance_type
  aws_iam_instance_profile = module.iam.aws_iam_instance_profile
  cluster_ca_certificate   = module.eks_cluster.cluster_ca_certificate
  frontend_subnet_ids      = module.vpc.frontend_subnet_ids
  eks_cluster_sg_id        = module.eks_cluster.eks_cluster_sg_id



}