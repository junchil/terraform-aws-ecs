resource "aws_ecs_cluster" "default" {
  name               = var.cluster_name
  capacity_providers = [aws_ecs_capacity_provider.asg.name]
  tags               = local.tags

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.asg.name
    weight            = 1
  }
}

resource "aws_ecs_capacity_provider" "asg" {
  name = aws_autoscaling_group.ecs_nodes.name

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_nodes.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = var.target_capacity
    }
  }
}