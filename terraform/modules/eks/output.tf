output "public_ips" {
  description = "Public IPs of the EKS node group instances"
  value       = data.aws_instances.eks_nodes.public_ips
  
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.this.name
  
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = aws_eks_cluster.this.endpoint
  
}