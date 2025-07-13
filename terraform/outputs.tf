output "region" {
  description = "The AWS region where resources are created"
  value       = local.region
}

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
  
}


output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}


output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.EC2.public_ip
}

output "eks_node_group_public_ips" {
  description = "Public IPs of the EKS node group instances"
  value       = module.eks.public_ips
}