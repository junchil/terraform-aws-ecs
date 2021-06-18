resource "aws_ecs_capacity_provider" "the-capacity-provider" {
  name = aws_autoscaling_group.ecs_nodes.name

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_nodes.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 86
    }
  }
}

resource "aws_ecs_cluster" "ecs-cluster" {
  name               = var.cluster_name
  tags               = local.tags

  capacity_providers = [aws_ecs_capacity_provider.the-capacity-provider.name]
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.the-capacity-provider.name
    weight            = 100
  }
}