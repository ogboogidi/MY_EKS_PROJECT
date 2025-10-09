variable "tags" {
  type = map(string)
}

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