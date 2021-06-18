resource "aws_autoscaling_group" "ecs_nodes" {
  name                  = "${var.cluster_name}-asg"
  max_size              = 2
  min_size              = 1
  vpc_zone_identifier   = var.subnet_ids
  protect_from_scale_in = false

  mixed_instances_policy {
    instances_distribution {
      on_demand_percentage_above_base_capacity = local.spot
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.node.id
        version            = "$Latest"
      }

      dynamic "override" {
        for_each = var.instance_types
        content {
          instance_type     = override.key
          weighted_capacity = override.value
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "AmazonECSManaged"
    propagate_at_launch = true
    value               = ""
  }
}

resource "aws_key_pair" "ssh-key-ec2" {
  key_name   = var.aws_key_pair_name
  public_key = file(var.aws_key_pair_public_key)
}

resource "aws_launch_template" "node" {
  name                   = var.cluster_name
  image_id               = var.ami_id
  instance_type          = "t3a.small"
  vpc_security_group_ids = local.sg_ids
  key_name               = aws_key_pair.ssh-key-ec2.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_node.name
  }

  user_data = base64encode(<<EOT
#!/bin/bash
echo ECS_CLUSTER="${var.cluster_name}" >> /etc/ecs/ecs.config
echo ECS_ENABLE_CONTAINER_METADATA=true >> /etc/ecs/ecs.config
echo ECS_ENABLE_SPOT_INSTANCE_DRAINING=${tostring(var.spot)} >> /etc/ecs/ecs.config
EOT
  )

  tag_specifications {
    resource_type = "instance"
    tags          = local.tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.tags
  }

  tags = local.tags
}