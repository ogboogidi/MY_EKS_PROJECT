resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.eks_cluster_name}-eks_cluster_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { 
            Service = "eks.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}


# Attach AWS managed policy required for EKS control plane
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Attach additional AWS managed policy EKS expects
resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}



# create worker node role and attachment
resource "aws_iam_role" "eks_worker_node" {
  name = "${var.eks_cluster_name}-eks_worker_node"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

#create worker node policy attcahemnts


# Allows worker nodes to connect to the cluster control plane
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role = aws_iam_role.eks_worker_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Required for VPC CNI plugin to manage networking (ENIs, IPs)
resource "aws_iam_role_policy_attachment" "CNI_policy" {
  role = aws_iam_role.eks_worker_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

#Allows worker nodes to pull container images from ECR
resource "aws_iam_role_policy_attachment" "ec2_container_registry_policy" {
  role = aws_iam_role.eks_worker_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

 #Attach CloudWatch Agent managed policy to the worker node role
resource "aws_iam_role_policy_attachment" "eks_cw_agent" {
  role = aws_iam_role.eks_worker_node.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  role = aws_iam_role.eks_worker_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

#########################################################################################################

resource "aws_iam_policy" "load_balancer_controller_policy" {
  name = "eks_workers_node_load_balancer_controller_policy"
  policy = file("${path.root}/iam_policy.json")
}


resource "aws_iam_role_policy_attachment" "load_balancer_controller" {
  role = aws_iam_role.eks_worker_node.name
  policy_arn = aws_iam_policy.load_balancer_controller_policy.arn
  
}

##########################################################################################################################
#create workers instance profile so that ec2 can assume node role

resource "aws_iam_instance_profile" "eks_workers_instance_profile" {
  name = "eks_workers_instance_profile"
  role = aws_iam_role.eks_worker_node.name
}