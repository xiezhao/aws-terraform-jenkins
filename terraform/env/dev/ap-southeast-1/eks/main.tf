module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.1.0"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  endpoint_private_access      = true
  endpoint_public_access       = true
  endpoint_public_access_cidrs = var.cluster_public_access_cidrs

  enable_cluster_creator_admin_permissions = true
  enable_irsa                              = false

  enabled_log_types                      = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cloudwatch_log_group_retention_in_days = var.log_retention_days

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  addons = {
    "amazon-cloudwatch-observability" = {
      configuration_values = jsonencode({
        manager = {
          applicationSignals = {
            autoMonitor = {
              monitorAllServices = false
            }
          }
        }
      })
      pod_identity_association = [{
        role_arn        = aws_iam_role.cloudwatch_observability.arn
        service_account = "cloudwatch-agent"
      }]
    }
  }

  tags = var.tags
}
