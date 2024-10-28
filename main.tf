# main.tf

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_vpc" "eks_vpc" {
  id = data.aws_eks_cluster.cluster.vpc_config[0].vpc_id
}

locals {
  user_data = base64encode(templatefile("${path.module}/templates/userdata.tpl", {
    cluster_name           = var.cluster_name
    cluster_endpoint       = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = data.aws_eks_cluster.cluster.certificate_authority[0].data
    cluster_service_cidr   = data.aws_eks_cluster.cluster.kubernetes_network_config[0].service_ipv4_cidr
  }))
}

module "eks_node_group_user_data" {
  source = "terraform-aws-modules/eks/aws//modules/_user_data"

  cluster_name          = var.cluster_name
  cluster_endpoint      = data.aws_eks_cluster.cluster.endpoint
  cluster_auth_base64   = data.aws_eks_cluster.cluster.certificate_authority[0].data
  cluster_service_cidr  = coalesce(var.cluster_service_cidr, data.aws_eks_cluster.cluster.kubernetes_network_config[0].service_ipv4_cidr)
  enable_bootstrap_user_data = true
}

resource "aws_launch_template" "eks_nodes" {
  name_prefix   = "${var.node_group_name}-template"
  image_id      = var.custom_ami_id
  instance_type = var.instance_type

  user_data = local.user_data
  vpc_security_group_ids = [aws_security_group.node_group_sg.id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.disk_size
      volume_type = "gp3"
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.node_group_name}-node"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = var.subnet_ids

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = aws_launch_template.eks_nodes.latest_version
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_group_AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}
