output "endpoint" {
  value = "access to here (wait a minute): http://${aws_lb.alb.dns_name}"
}

resource "aws_lb" "alb" {
  name               = "${var.general_name}-application"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = [aws_subnet.subnet_a.id, aws_subnet.subnet_c.id]
  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "alb" {
  name        = var.general_name
  port        = 8089
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    matcher             = "200,304"
    path                = "/"
  }

  depends_on = [aws_lb.alb] 
}

resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.alb.arn
    type             = "forward"
  }
}

resource "aws_security_group" "lb" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.general_name}-lb"
  description = "Security group for ${var.general_name}-lb"

  ingress {
    from_port   = 80
    to_port     = 8089
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
