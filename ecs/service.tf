resource "aws_ecs_service" "bar" {
  name            = "efs-example-service"
  cluster         = aws_ecs_cluster.default.id
  task_definition = aws_ecs_task_definition.efs-task.arn
  desired_count   = 2

  capacity_provider_strategy {
    base              = 1
    capacity_provider = aws_ecs_capacity_provider.asg.name
    weight            = 1
  }
}

data "template_file" "nginx_app" {
  template = file("./ecs/nginx.json")
}

resource "aws_ecs_task_definition" "efs-task" {
  family                = "efs-example-task"
  container_definitions = data.template_file.nginx_app.rendered

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
