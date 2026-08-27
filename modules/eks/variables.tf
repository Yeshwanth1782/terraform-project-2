variable "subnet_ids" {
  description = "Subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "node_subnet_ids" {
  description = "Subnet IDs for EKS worker nodes"
  type        = list(string)
}