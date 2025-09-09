variable "project" {
  description = "Name/prefix for tagging AWS resources"
  type        = string
  default     = "demo-net"
}

variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "internet_gateway" {
  description = "name for internet gateway"
  type        = string
  default     = "my-IGW"
}

variable "el_ip" {
  description = "name for elastic ip"
  type        = string
  default     = "my-el-ip"
}

# Provide exactly 3 AZs (you can leave the defaults or override them)
variable "azs" {
  description = "List of 3 availability zones to use (order matters for CIDR indexing)"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
  validation {
    condition     = length(var.azs) == 3
    error_message = "azs must contain exactly 3 availability zones."
  }
}

variable "public_subnet_cidrs" {
  description = "List of three CIDRs for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  validation {
    condition     = length(var.public_subnet_cidrs) == 3
    error_message = "public_subnet_cidrs must contain exactly 3 CIDRs."
  }
}

variable "private_subnet_cidrs" {
  description = "List of three CIDRs for private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  validation {
    condition     = length(var.private_subnet_cidrs) == 3
    error_message = "private_subnet_cidrs must contain exactly 3 CIDRs."
  }
}
