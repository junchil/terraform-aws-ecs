resource "aws_ecs_service" "nginx-service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.efs-task.arn
  desired_count   = 1

  capacity_provider_strategy {
    base              = 1
    capacity_provider = aws_ecs_capacity_provider.the-capacity-provider.name
    weight            = 1
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.nginx_app.id
    container_name   = "nginx"
    container_port   = 80
  }

  network_configuration {
    subnets = var.subnet_ids
  }

  depends_on = [aws_alb_listener.front_end]
}

data "template_file" "nginx_app" {
  template = file("./cluster/nginx/nginx.json")
}

resource "aws_ecs_task_definition" "efs-task" {
  family                = "nginx-task"
  container_definitions = data.template_file.nginx_app.rendered
  network_mode = "awsvpc"

  # volume {
  #   name = "efs-html"

  #   efs_volume_configuration {
  #     file_system_id     = aws_efs_file_system.foo.id
  #     root_directory     = "/"
  #     transit_encryption = "ENABLED"

  #     authorization_config {
  #       access_point_id = aws_efs_access_point.this.id
  #       iam             = "DISABLED"
  #     }
  #   }
  # }
}
