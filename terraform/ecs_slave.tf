resource "aws_ecs_service" "slave" {
  name            = "locust-slave"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.slave.arn
  desired_count   = var.slave_count

  network_configuration {
    subnets          = [aws_subnet.subnet_a.id]
    security_groups  = [aws_security_group.slave.id]
    assign_public_ip = true
  }
}

resource "aws_security_group" "slave" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.general_name}-locust-slave-security group"
  description = "Security group for ${var.general_name}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
