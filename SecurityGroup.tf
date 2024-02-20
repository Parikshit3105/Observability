############################################################################## security_group ######################################################################################
# Create Security Group for EC2 instance
resource "aws_security_group" "Prod-observability-sg" {
  name        = "Prod-observability-sg"
  description = "Allow inbound all the exporters metrics and traffic"
  vpc_id      = var.vpc_id  # Specify your VPC ID

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    description = "Node-Exporter"
    cidr_blocks = [var.vpc_cidr]  # Specify your VPC CIDR range
  }

  ingress {
    from_port   = 28080
    to_port     = 28080
    protocol    = "tcp"
    description = "cadvisor-Exporter"
    cidr_blocks = [var.vpc_cidr]  # Specify your VPC CIDR range
  }

  ingress {
    from_port   = 9419
    to_port     = 9419
    protocol    = "tcp"
    description = "Rabbit-MQ-Exporter"
    cidr_blocks = [var.vpc_cidr]  # Specify your VPC CIDR range
  }

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    description = "EFS"
    cidr_blocks = [var.vpc_cidr]  # Specify your VPC CIDR range
  }

  ingress {
    from_port   = 9107
    to_port     = 9107
    protocol    = "tcp"
    description = "Consul-Exporter"
    cidr_blocks = [var.vpc_cidr]  # Specify your VPC CIDR range
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    description = "Grafana"
    cidr_blocks = [var.vpc_cidr]  # Specify your VPC CIDR range
  }

  ingress {
    from_port   = 9114
    to_port     = 9114
    protocol    = "tcp"
    description = "ElasticSearch-Exporter"
    cidr_blocks = [var.vpc_cidr]  # Specify your VPC CIDR range
  }

  ingress {
    from_port   = 9121
    to_port     = 9121
    protocol    = "tcp"
    description = "Redis-Exporter"
    cidr_blocks = [var.vpc_cidr]  # Specify your VPC CIDR range
  }

  ingress {
    from_port   = 8070
    to_port     = 8070
    protocol    = "tcp"
    description = "JMX-Cassanrda-Exporter"
    cidr_blocks = [var.vpc_cidr]  # Specify your VPC CIDR range
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    description = "Promethious"
    cidr_blocks = [var.vpc_cidr]  # Specify your VPC CIDR range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "Allow all outbound traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Prod-observability-sg"
    Environment = "${var.observability_server}"
    Functionality = "Observability"
  }
}

#----ALB security group--------------------
resource "aws_security_group" "alb_observability_server_sg" {
  vpc_id = var.vpc_id
  name = "${var.observability_server}-alb-sg"
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.observability_server}-alb-sg"
    Environment = "${var.observability_server}"
  }
}