output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

#output "zz_update_kubeconfig_command" {
  # value = "aws eks update-kubeconfig --name " + module.eks.cluster_id
#  value = format("%s %s %s %s", "aws eks update-kubeconfig --name", module.eks.cluster_id, "--region", var.aws_region)
#}

# RDS MySQL Outputs
output "rds_endpoint" {
  description = "The connection endpoint for the RDS MySQL instance"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_port" {
  description = "The port the RDS MySQL instance is listening on"
  value       = aws_db_instance.mysql.port
}

output "rds_username" {
  description = "The master username for the RDS MySQL instance"
  value       = aws_db_instance.mysql.username
  sensitive   = true
}

output "rds_database_name" {
  description = "The name of the database"
  value       = aws_db_instance.mysql.db_name
}

output "rds_connection_string" {
  description = "MySQL connection string"
  value       = "mysql://${aws_db_instance.mysql.username}:${aws_db_instance.mysql.password}@${aws_db_instance.mysql.endpoint}/${aws_db_instance.mysql.db_name}"
  sensitive   = true
}
