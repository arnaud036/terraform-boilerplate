
resource "aws_iam_role" "task_execution_role" {
    name = "${var.prefix}-task-execution-role"
    assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
          type = "Service"
          identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
    role = aws_iam_role.task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster" "default" {
    name = var.prefix
}

# resource "aws_ecs_cluster_capacity_providers" "default" {
#   cluster_name = aws_ecs_cluster.default.name

#   capacity_providers = ["FARGATE_SPOT", "FARGATE"]

#   default_capacity_provider_strategy {
#     capacity_provider = "FARGATE_SPOT"
#   }
# }

resource "aws_cloudwatch_log_group" "default" {
    name = "/ecs/${var.prefix}"
    retention_in_days = 30
}

resource "aws_ecs_task_definition" "default" {
    family = "${var.prefix}-task"
    
    container_definitions = jsonencode([
        {
            name = var.prefix,
            image = "${var.docker_image}:${var.docker_tag}",
            entryPoint = [],
            environment = var.container_environment
            essential = true,
            logConfiguration = {
                logDriver = "awslogs",
                options = {
                    awslogs-region = var.aws_region,
                    awslogs-group = aws_cloudwatch_log_group.default.id
                    awslogs-stream-prefix = var.prefix
                }
            },
            portMappings = [
                { containerPort = var.container_port }
            ]
        }
    ])
    
    cpu     = var.container_cpu
    memory  = var.container_memory
    requires_compatibilities = ["FARGATE"]

    network_mode = "awsvpc"

    execution_role_arn = aws_iam_role.task_execution_role.arn
}

resource "aws_ecs_service" "default" {
    name            = var.prefix
    task_definition = aws_ecs_task_definition.default.arn
    cluster         = aws_ecs_cluster.default.id

    launch_type     = "FARGATE"
    desired_count   = 1

    network_configuration {
        assign_public_ip = false

        security_groups = [
            aws_security_group.egress_all.id,
            aws_security_group.default.id,
        ]

        subnets = var.subnet_ids
    }
}
