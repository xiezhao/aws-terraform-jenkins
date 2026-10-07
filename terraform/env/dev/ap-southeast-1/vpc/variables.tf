variable "aws_region" {
  description = "AWS Region for the VPC."
  type        = string
}

variable "name" {
  description = "Name of the VPC."
  type        = string
}

variable "cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "Availability zones used for the VPC subnets."
  type        = list(string)
}

variable "private_subnets" {
  description = "IPv4 CIDR blocks for the private subnets."
  type        = list(string)
}

variable "public_subnets" {
  description = "IPv4 CIDR blocks for the public subnets."
  type        = list(string)
}

variable "public_subnet_tags" {
  description = "Tags used to identify subnets for internet-facing load balancers."
  type        = map(string)
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT gateways for private subnet egress."
  type        = bool
}

variable "single_nat_gateway" {
  description = "Whether all private subnets share one NAT gateway."
  type        = bool
}

variable "enable_vpn_gateway" {
  description = "Whether to create a VPN gateway."
  type        = bool
}

variable "tags" {
  description = "Tags applied to VPC resources."
  type        = map(string)
}
