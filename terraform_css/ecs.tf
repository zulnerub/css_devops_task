#
# Define ECS CLUSTER:
#
resource "aws_ecs_cluster" "css_ecs_cluster" {
  name = join("-", [  var.env_prefix, "cluster"])
}

#
# Define cloud watch:
#
resource "aws_cloudwatch_log_group" "css_log_group" {
  name = var.css_app_log_group
  tags = {
    Name = var.css_app_log_group
  }
}

#
# Define ECS TASK:
# 
resource "aws_ecs_task_definition" "css_ecs_task_definition" {
  family                   = join("-", [ var.env_prefix,"task_def" ])
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.css_app_cpu
  memory                   = var.css_app_memory
  execution_role_arn       = var.aws_kvasilev_arn
  container_definitions = <<DEFINITION
[
  {
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "${var.css_app_log_group}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [
      {
        "hostPort": 8080,
        "protocol": "tcp",
        "containerPort": 8080
      }
    ],
    "environment": [
      {
        "name": "PASS_VAR",
        "value": "dummy_value"
      }
    ],
    "ulimits": [
        {
          "softLimit": 102400,
          "hardLimit": 102400,
          "name": "nofile"
        }
    ],
    "image": "${var.css_app_image}",
    "name": "${var.env_prefix}-container",
    "cpu": ${var.css_app_cpu},
    "memory": ${var.css_app_memory},
    "essential": true
  }
]
DEFINITION
}

#
# Application load balancer
#
resource "aws_lb" "css_application_load_balancer" {
  name               = join("-", [var.env_prefix, "alb"])
  #name              = "hawkbit-prod-hawkbit-alb"
  load_balancer_type = "application"
  idle_timeout       = 300
  subnets            = [aws_subnet.css_subnet_zone_a.id,aws_subnet.css_subnet_zone_b.id]
  security_groups    = [aws_security_group.css_security_group.id]
  ip_address_type    = "ipv4"
  tags = {
    Name = join("-", [ var.env_prefix, "alb" ])
  }
}

#
# Application load balancer target group
#
resource "aws_alb_target_group" "css_application_load_balancer_target_group" {
  name        =  join("-", [ var.env_prefix, "tg"])
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.css_vpc.id
  target_type = "ip"
  health_check {
    path                = "/"
    port                = 8080
    interval            = 180
    timeout             = 120
    unhealthy_threshold = 5
    healthy_threshold   = 2
    matcher             = 200
  }
  tags = {
    Name = join("-", [ var.env_prefix, "tg" ])
  }
}

#
# Application load balancer listener
#
resource "aws_alb_listener" "css_application_load_balancer_listener" {
  load_balancer_arn = aws_lb.css_application_load_balancer.arn
  port              = 8080
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.css_application_load_balancer_target_group.arn
    type             = "forward"
  }
}

#
# Define ECS SERVICE
#
resource "aws_ecs_service" "css_ecs_service" {
  name               = join("-", [ var.env_prefix, "svc"])
  cluster            = aws_ecs_cluster.css_ecs_cluster.id
  task_definition    = aws_ecs_task_definition.css_ecs_task_definition.id
  desired_count      = var.css_app_count
  launch_type        = "FARGATE"
  health_check_grace_period_seconds = var.css_app_health_check_grace_period
  tags = {
    Name = join("-", [ var.env_prefix, "svc" ])
  }
  network_configuration {
    security_groups  = [aws_security_group.css_security_group.id]
    subnets          = [aws_subnet.css_subnet_zone_a.id,aws_subnet.css_subnet_zone_b.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.css_application_load_balancer_target_group.arn
    container_name   = join("-", [ var.env_prefix, "container"])
    container_port   = 8080
  }
  depends_on = [
    aws_alb_listener.css_application_load_balancer_listener
  ]
}
