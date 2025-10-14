variable "eks_cluster_name" {
  type = string
}

variable "eks_cluster_role_arn" {
  type = string
}

variable "backend_subnet_ids" {
  type = list(string)
}

variable "eks_cluster_policy_attachment" {
  type = string
}

variable "eks_service_policy_attachment" {
  type = string
}

variable "vpc_id" {
  type = string
}

