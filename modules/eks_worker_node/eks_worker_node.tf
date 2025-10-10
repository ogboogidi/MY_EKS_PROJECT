#create security groups for woker nodes

resource "aws_security_group" "eks_workers_node_sg" {
  name = "eks_workers_node_sg"
  vpc_id = var.vpc_id
  description = "Allow specific connections"

  tags = {
    Name = "eks_workers_node_sg"
  }

}



resource "aws_vpc_security_group_ingress_rule" "allow_nodeport_tcp" {
  security_group_id = aws_security_group.eks_workers_node_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 30000
  ip_protocol = "tcp"
  to_port = 32767
  description = "Allow NodePort traffic over TCP"
}


resource "aws_vpc_security_group_ingress_rule" "allow_SSH" {
  security_group_id = aws_security_group.eks_workers_node_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
  description = "allow SSH"
}


resource "aws_vpc_security_group_ingress_rule" "allow_eks_cluster_api_server" {
  security_group_id = aws_security_group.eks_workers_node_sg.id
  referenced_security_group_id = aws_security_group.eks_cluster_sg.id
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
  description = "allow the control plane api server to communicate with kubelet in the workers node"
}


resource "aws_vpc_security_group_ingress_rule" "allow_workers_node_connection" {
  security_group_id = aws_security_group.eks_workers_node_sg.id
  cidr_ipv4 = var.vpc_cidr_block
  from_port = 0
  ip_protocol = "tcp"
  to_port = 65535
  description = "allow nodes to communicate with each other"
}




resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_eks_workers_node" {
  security_group_id = aws_security_group.eks_workers_node_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}



#create a launch template for eks_workers_node auto scaling group

resource "aws_launch_template" "eks_lt" {
  name_prefix = "${var.eks_cluster_name}-lt"
  image_id = var.image_id
  key_name = var.key_name
  instance_type = var.instance_type


  network_interfaces {
    security_groups = aws_security_group.eks_workers_node_sg.id
    associate_public_ip_address = true
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_type = "gp2"
      volume_size = 20
    }
  }

  iam_instance_profile {
    name = var.aws_iam_instance_profile
  }


 user_data = base64encode(<<-EOF
 #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh ${var.eks_cluster_name} \
      --apiserver-endpoint ${var.eks_cluster_endpoint} \
      --b64-cluster-ca ${var.cluster_ca_certificate}
    EOF
 )
}


#CREATE HE ASG

resource "aws_autoscaling_group" "eks_workers_node_asg" {
  desired_capacity = 2
  max_size = 3
  min_size = 1


  launch_template {
    id = aws_launch_template.eks_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier = var.frontend_subnet_ids[*]

  tag {
    key = "kubernetes.io/cluster/${var.eks_cluster_name}"
    value = "owned"
    propagate_at_launch = true
  }
  

  depends_on = [ aws_launch_template.eks_lt ]

}