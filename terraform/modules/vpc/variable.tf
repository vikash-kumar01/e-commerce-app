variable "vpc_name" {
  description = "Name of the VPC"
  default     = "my-vpc"
  
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = ""
  
}

variable "azs" {
  description = "Availability Zones for the VPC"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  
}


variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = [""]  
  
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = [""]  
  
}