resource "aws_ecs_service" "bar" {
  name            = "efs-example-service"
  cluster         = aws_ecs_cluster.default.id
  task_definition = aws_ecs_task_definition.efs-task.arn
  desired_count   = 2
  launch_type     = "EC2"
}

resource "aws_ecs_task_definition" "efs-task" {
  family = "efs-example-task"

  container_definitions = <<DEFINITION
[
  {
      "memory": 128,
      "portMappings": [
          {
              "hostPort": 80,
              "containerPort": 80,
              "protocol": "tcp"
          }
      ],
      "essential": true,
      "mountPoints": [
          {
              "containerPath": "/usr/share/nginx/html",
              "sourceVolume": "efs-html"
          }
      ],
      "name": "nginx",
      "image": "nginx"
  }
]
DEFINITION

  volume {
    name = "efs-html"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.foo.id
      root_directory = "/path/to/my/data"
    }
  }
}
