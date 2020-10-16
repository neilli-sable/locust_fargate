resource "aws_ecs_service" "master" {
  name            = "locust-master"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.master.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.alb.arn
    container_name   = "locust-master"
    container_port   = 8089
  }

  network_configuration {
    subnets          = [aws_subnet.subnet_a.id]
    security_groups  = [aws_security_group.master.id]
    assign_public_ip = true
  }

  service_registries {
    registry_arn = aws_service_discovery_service.master.arn
  }
}

resource "aws_security_group" "master" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.general_name}-locust-master-security group"
  description = "Security group for ${var.general_name}"

  ingress {
    from_port   = 8089
    to_port     = 8089
    protocol    = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  ingress {
    from_port   = 5557
    to_port     = 5557
    protocol    = "tcp"
    security_groups = [aws_security_group.worker.id]
  }

  ingress {
    from_port   = 5558
    to_port     = 5558
    protocol    = "tcp"
    security_groups = [aws_security_group.worker.id]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
