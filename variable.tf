variable "vpc_cidr_block" {
  type = string
}

variable "availability_zone" {
  type = list(string)
}

variable "frontend_subnets_cidr_block" {
  type = list(string)
}

variable "backend_subnets_cidr_block" {
  type = list(string)
}

variable "eks_cluster_name" {
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