resource "aws_ecs_service" "worker" {
  name            = "locust-worker"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.worker.arn
  desired_count   = var.worker_count

  network_configuration {
    subnets          = [aws_subnet.subnet_a.id]
    security_groups  = [aws_security_group.worker.id]
    assign_public_ip = true
  }
}

resource "aws_security_group" "worker" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.general_name}-locust-worker-security group"
  description = "Security group for ${var.general_name}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
