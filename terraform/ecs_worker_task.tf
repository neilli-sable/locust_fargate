resource "aws_ecs_task_definition" "worker" {
  family = "locust-worker"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.fargate_cpu},
    "essential": true,
    "image": "${var.locust_container}",
    "memoryReservation": ${var.fargate_memory},
    "name": "locust-worker",
    "command": ["-f", "${var.locust_script_path}", "--worker", "--master-host=master.locust.internal"]
  }
]
DEFINITION
}
