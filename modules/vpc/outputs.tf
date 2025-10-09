output "vpc_id" {
  value = aws_vpc.eks_main_vpc.id
}

output "frontend_subnet_ids" {
  value = [ 
    aws_subnet.eks_frontend_subnet_01_AZ1a.id,
    aws_subnet.eks_frontend_subnet_02_AZ1b.id
    ]
}

output "backend_subnet_ids" {
  value = [ 
    aws_subnet.eks_backend_subnet_03_AZ1a.id,
    aws_subnet.eks_backend_subnet_04_AZ1b.id
    ]
}