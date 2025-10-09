#create main vpc for eks cluster

resource "aws_vpc" "eks_main_vpc" {
  cidr_block = var.vpc_cidr_block


  tags = merge(var.tags, {
  Name = "${var.tags.project}, ${var.tags.application}, ${var.tags.environment}-main_vpc"
    }
  )
}



#######################################################################################################################
#create internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_main_vpc.id


   tags = merge(var.tags, {
  Name = "${var.tags.project}, ${var.tags.application}, ${var.tags.environment}-main_vpc"
    }
  )
}


#######################################################################################################################
#create frontend subnets in AZ1a and AZ1b

resource "aws_subnet" "eks_frontend_subnet_01_AZ1a" {
  vpc_id = aws_vpc.eks_main_vpc.id
  availability_zone = var.availability_zone[0]
  cidr_block = var.frontend_subnets_cidr_block[0]
  map_public_ip_on_launch = true


    tags = merge(var.tags, {
  Name = "${var.tags.project}, ${var.tags.application}, ${var.tags.environment}-frontend_subnet_01_AZ1a"
    }
  )
}


resource "aws_subnet" "eks_frontend_subnet_02_AZ1b" {
  vpc_id = aws_vpc.eks_main_vpc.id
  availability_zone = var.availability_zone[1]
  cidr_block = var.frontend_subnets_cidr_block[1]
  map_public_ip_on_launch = true


    tags = merge(var.tags, {
  Name = "${var.tags.project}, ${var.tags.application}, ${var.tags.environment}-frontend_subnet_02_AZ1b"
    }
  )
}




#######################################################################################################################
#create backend subnets in AZ1a and AZ1b

resource "aws_subnet" "eks_backend_subnet_03_AZ1a" {
  vpc_id = aws_vpc.eks_main_vpc.id
  availability_zone = var.availability_zone[0]
  cidr_block = var.backend_subnets_cidr_block[0]
  map_public_ip_on_launch = false


    tags = merge(var.tags, {
  Name = "${var.tags.project}, ${var.tags.application}, ${var.tags.environment}-backend_subnet_03_AZ1a"
    }
  )
}


resource "aws_subnet" "eks_backend_subnet_04_AZ1b" {
  vpc_id = aws_vpc.eks_main_vpc.id
  availability_zone = var.availability_zone[1]
  cidr_block = var.backend_subnets_cidr_block[1]
  map_public_ip_on_launch = false


    tags = merge(var.tags, {
  Name = "${var.tags.project}, ${var.tags.application}, ${var.tags.environment}-frontend_subnet_04_AZ1b"
    }
  )
}



#######################################################################################################################
#create public route table for frontend subnets in AZ1a and AZ1b

resource "aws_route_table" "eks_public_rt" {
  vpc_id = aws_vpc.eks_main_vpc.id

  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
 }

    tags = merge(var.tags, {
  Name = "${var.tags.project}, ${var.tags.application}, ${var.tags.environment}-public_rt"
    }
  )
}


resource "aws_route_table_association" "frontend_subnet_01_AZ1a" {
  route_table_id = aws_route_table.eks_public_rt.id
  subnet_id = aws_subnet.eks_frontend_subnet_01_AZ1a.id
}

resource "aws_route_table_association" "frontend_subnet_02_AZ1b" {
  route_table_id = aws_route_table.eks_public_rt.id
  subnet_id = aws_subnet.eks_frontend_subnet_02_AZ1b.id
}


#######################################################################################################################
#create EIP for NAT-gateway for backend subnet in AZ1a

resource "aws_eip" "eip_AZ1a" {
  domain = "vpc"

}


#######################################################################################################################
#create EIP for NAT-gateway for backend subnet in AZ1b

resource "aws_eip" "eip_AZ1b" {
  domain = "vpc"
  
}

#######################################################################################################################
#create NAT-gateway for backend subnet in AZ1a

resource "aws_nat_gateway" "nat_gw_AZ1a" {
  subnet_id = aws_subnet.eks_frontend_subnet_01_AZ1a.id
  allocation_id = aws_eip.eip_AZ1a.id
  

  depends_on = [ aws_eip.eip_AZ1a, aws_subnet.eks_frontend_subnet_01_AZ1a ]


    tags = merge(var.tags, {
  Name = "${var.tags.project}, ${var.tags.application}, ${var.tags.environment}-nat_gw_AZ1a"
    }
  )

}


#######################################################################################################################
#create NAT-gateway for backend subnet in AZ1b

resource "aws_nat_gateway" "nat_gw_AZ1b" {
  subnet_id =aws_subnet.eks_frontend_subnet_02_AZ1b.id
  allocation_id = aws_eip.eip_AZ1b.id
  

  depends_on = [ aws_eip.eip_AZ1b, aws_subnet.eks_frontend_subnet_02_AZ1b ]


    tags = merge(var.tags, {
  Name = "${var.tags.project}, ${var.tags.application}, ${var.tags.environment}-nat_gw_AZ1b"
    }
  )
}




#######################################################################################################################
#create private route table for backend subnet in AZ1a 

resource "aws_route_table" "eks_private_rt_AZ1a" {
  vpc_id = aws_vpc.eks_main_vpc.id

  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat_gw_AZ1a.id
 }

     tags = merge(var.tags, {
  Name = "${var.tags.project}, ${var.tags.application}, ${var.tags.environment}-private_rt_AZ1a"
    }
  )
}


resource "aws_route_table_association" "backend_subnet_03_AZ1a" {
  route_table_id = aws_route_table.eks_private_rt_AZ1a.id
  subnet_id = aws_subnet.eks_backend_subnet_03_AZ1a.id
}


#######################################################################################################################
#create private route table for backend subnet in AZ1b 

resource "aws_route_table" "eks_private_rt_AZ1b" {
  vpc_id = aws_vpc.eks_main_vpc.id

  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat_gw_AZ1b.id
 }

     tags = merge(var.tags, {
  Name = "${var.tags.project}, ${var.tags.application}, ${var.tags.environment}-private_rt_AZ1b"
    }
  )
}


resource "aws_route_table_association" "backend_subnet_04_AZ1b" {
  route_table_id = aws_route_table.eks_private_rt_AZ1b.id
  subnet_id = aws_subnet.eks_backend_subnet_04_AZ1b.id
}