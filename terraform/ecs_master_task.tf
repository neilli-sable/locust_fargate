data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "master" {
  family = "locust-master"
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
    "name": "locust-master",
    "command": ["-f", "${var.locust_script_path}", "--master"],
    "portMappings": [
      {
        "containerPort": 8089,
        "hostPort": 8089
      },
      {
        "containerPort": 5557,
        "hostPort": 5557
      },
      {
        "containerPort": 5558,
        "hostPort": 5558
      }
    ]
  }
]
DEFINITION
}
