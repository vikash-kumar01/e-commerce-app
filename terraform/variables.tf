variable "aws_region" {
  description = "AWS region where resources will be provisioned"
  default     = "us-east-2"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0e001c9271cf7f3b9"
}
variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t3.medium"
}

variable "my_enviroment" {
  description = "Instance type for the EC2 instance"
  default     = "dev"
}

variable "key_name" {
  description = "Name of the SSH key pair to use for the EC2 instance"
  default     = "terra-automate-key"
  
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "my-eks-cluster"
  
}

variable "aws_account_id" {
  description = "AWS Account ID"
  default     = "897722689734"
  
}
