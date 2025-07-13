variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "my-eks-cluster"
  
}

variable "aws_account_id" {
  description = "AWS Account ID"
  default     = "897722689734"
  
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "EKS"
  }
  
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}


variable "public_subnets" {
  description = "List of public subnet IDs for the EKS cluster"
  type        = list(string)
  
}

variable "private_subnets" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
  
}

variable "key_name" {
  description = "Name of the SSH key pair to use for the EKS worker nodes"
  default     = "terra-automate-key"
  
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.31"
  
}