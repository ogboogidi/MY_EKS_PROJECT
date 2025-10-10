#create security groups for the eks_cluster

resource "aws_security_group" "eks_cluster_sg" {
  name = "eks_cluster_sg"
  description = "Allow ....................."
  vpc_id = var.vpc_id

  tags = {
    "name" = "eks_cluster_sg"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_http_api_request" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
  description = ".............."
}


resource "aws_vpc_security_group_ingress_rule" "allow_https_api_request" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
  description = "allow https api request packets to the kube-api-server from the anywhere (vpc, nodes or kubectl client)"
}


resource "aws_vpc_security_group_ingress_rule" "allow_dns" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 53
  ip_protocol = "udp"
  to_port = 53
  description = "allow route 53 for dns resolution"
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_eks_cluster" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}


# create the eks cluster resource

resource "aws_eks_cluster" "eks_cluster" {
  name = "${var.eks_cluster_name}"
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids = var.backend_subnet_ids[*]
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  depends_on = [ var.eks_cluster_policy_attachment, var.eks_service_policy_attachment ] 
}