# outputs.tf

output "node_group_arn" {
  description = "ARN of the EKS Node Group"
  value       = aws_eks_node_group.main.arn
}

output "node_group_id" {
  description = "ID of the EKS Node Group"
  value       = aws_eks_node_group.main.id
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = aws_eks_node_group.main.status
}
