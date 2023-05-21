resource "aws_security_group" "egress_all" {
  name        = "${var.prefix}-egress-all"
  description = "Allow all outbound traffic"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "default" {
  name        = var.prefix
  description = "Allow ingress to container"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
