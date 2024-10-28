resource "aws_security_group" "node_group_sg" {
  name_prefix = "${var.node_group_name}-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
 }

  tags = {
    Name = "${var.node_group_name}-sg"
  }
}
