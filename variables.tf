# variables.tf

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "custom_ami_id" {
  description = "Custom AMI ID to use for the node group"
  type        = string
}

variable "node_group_name" {
  description = "Name of the EKS managed node group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the node group will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the nodes will be created"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for the node group"
  type        = string
  default     = "t3.medium"
}

variable "cluster_service_cidr" {
  description = "The CIDR block for Kubernetes services in the cluster"
  type        = string
  default     = ""
}

variable "disk_size" {
  description = "Disk size in GiB for worker nodes"
  type        = number
  default     = 20
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}
