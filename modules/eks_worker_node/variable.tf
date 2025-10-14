variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "image_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "aws_iam_instance_profile" {
  type = string
}

variable "eks_cluster_endpoint" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

 variable "frontend_subnet_ids" {
   type = list(string)
 }

variable "eks_cluster_sg_id" {
  type = string
}

