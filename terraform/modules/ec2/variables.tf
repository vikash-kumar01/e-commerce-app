variable "key_name" {
  description = "Name of the SSH key pair to use for the EC2 instance"
  default     = "terra-automate-key"
  
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t3.medium"
  
}

variable "vpc_id" {
  description = "VPC ID where the EC2 instance will be deployed"
  type        = string
  
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be deployed"
  type        = string
  
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  
}