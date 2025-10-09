vpc_cidr_block              = "10.0.0.0/16"
frontend_subnets_cidr_block = ["10.0.0.0/24", "10.0.1.0/24"]
backend_subnets_cidr_block  = ["10.0.2.0/24", "10.0.3.0/24"]
availability_zone           = ["us-east-1a", "us-east-1b"]
eks_cluster_name            = "kubernetes.io_cluster"