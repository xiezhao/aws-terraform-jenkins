output "vpc_id" {
  description = "VPC ID to pass to the EKS stack."
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs to pass to the EKS stack."
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "Public subnet IDs used by the internet-facing ALB."
  value       = module.vpc.public_subnets
}
