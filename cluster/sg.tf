resource "aws_security_group" "ecs_nodes" {
  name   = "ECS nodes for ${var.cluster_name}"
  vpc_id = var.vpc_id
  tags   = local.tags
}

resource "aws_security_group_rule" "ingress" {
  from_port         = 80
  to_port           = 80
  protocol          = "-1"
  cidr_blocks       = var.trusted_cidr_blocks
  security_group_id = aws_security_group.ecs_nodes.id
  type              = "ingress"
}

resource "aws_security_group_rule" "egress" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_nodes.id
  type              = "egress"
}