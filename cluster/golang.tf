resource "aws_ecs_service" "golang-service" {
  name            = "golang-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.golang-task.arn
  desired_count   = 1

  capacity_provider_strategy {
    base              = 1
    capacity_provider = aws_ecs_capacity_provider.the-capacity-provider.name
    weight            = 1
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.golang_app.id
    container_name   = "golang"
    container_port   = 3000
  }

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.golang_sg.id]
  }
}

data "template_file" "golang_app" {
  template = file("./cluster/golang.json")
}

resource "aws_ecs_task_definition" "golang-task" {
  family                = "golang-task"
  container_definitions = data.template_file.golang_app.rendered
  network_mode          = "awsvpc"

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

resource "aws_security_group" "golang_sg" {
  name   = "golang service sg"
  vpc_id = var.vpc_id
  tags   = local.tags
}

resource "aws_security_group_rule" "golang_sg_http_ingress" {
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = var.trusted_cidr_blocks
  security_group_id = aws_security_group.golang_sg.id
  type              = "ingress"
}

resource "aws_security_group_rule" "golang_sg_egress" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.golang_sg.id
  type              = "egress"
}
