variable "aws_region" {
  description = "AWS Region for the EKS cluster and its log groups."
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes minor version for the EKS cluster."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC created by the VPC stack."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS Auto Mode nodes and control plane interfaces."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "Provide private subnets in at least two Availability Zones."
  }
}

variable "cluster_public_access_cidrs" {
  description = "CIDR ranges allowed to reach the public EKS API endpoint."
  type        = list(string)

  validation {
    condition     = length(var.cluster_public_access_cidrs) > 0
    error_message = "Provide at least one CIDR for administrator access."
  }
}

variable "log_retention_days" {
  description = "Retention period for EKS control plane and application logs in CloudWatch."
  type        = number
}

variable "tags" {
  description = "Tags applied to EKS, IAM, and CloudWatch resources."
  type        = map(string)
}
