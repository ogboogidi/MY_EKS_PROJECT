output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}


output "eks_cluster_policy_attachment" {
  value = aws_iam_role_policy_attachment.eks_cluster_policy.id
}

output "eks_service_policy_attachment" {
  value = aws_iam_role_policy_attachment.eks_service_policy.id
}


#outputs for worker_nodes

output "eks_worker_node_arn" {
  value = aws_iam_role.eks_worker_node.name
}

output "eks_worker_node_policy_attachment" {
  value = aws_iam_role_policy_attachment.eks_worker_node_policy.id
}

output "AmazonEKS_CNI_Policy_attachment" {
value = aws_iam_role_policy_attachment.CNI_policy.id
}

output "ec2_container_registry_policy" {
  value = aws_iam_role_policy_attachment.ec2_container_registry_policy.id
}

output "load_balancer_controller" {
  value = aws_iam_role_policy_attachment.load_balancer_controller.id
}           

output "eks_cw_agent" {
  value = aws_iam_role_policy_attachment.eks_cw_agent.id
}           
       

output "AmazonEC2ContainerRegistryReadOnly" {
  value = aws_iam_role_policy_attachment.AmazonEKSVPCResourceController.id
}





output "aws_iam_instance_profile" {
  value = aws_iam_instance_profile.eks_workers_instance_profile.name
}  