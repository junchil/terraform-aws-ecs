locals {
  spot   = var.spot == true ? 50 : 50
  sg_ids = distinct(concat(var.security_group_ids, [aws_security_group.ecs_nodes.id]))
  tags = merge({
    Name   = var.cluster_name,
    Module = "ECS Cluster"
  }, var.tags)
}