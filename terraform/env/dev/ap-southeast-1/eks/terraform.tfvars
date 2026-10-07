aws_region         = "ap-southeast-1"
cluster_name       = "demo-eks-dev"
kubernetes_version = "1.33"

vpc_id             = "vpc-045f90f0a54e10b18"
private_subnet_ids = ["subnet-09ecb68f8abaed7c8", "subnet-0fa8650443c5d7be5", "subnet-0672f31ccf75670d4"]

cluster_public_access_cidrs = ["0.0.0.0/0"]
log_retention_days          = 7

tags = {
  Environment = "dev"
  Terraform   = "true"
}
