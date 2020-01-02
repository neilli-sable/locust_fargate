resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.general_name}-${terraform.workspace}"
}
