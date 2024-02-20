## Creating Admin Launch template
resource "aws_launch_template" "launch_template-observability" {
  name                        = "${var.observability_server}-lt"
  image_id                    = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.Prod-observability-sg.id]
  user_data                   = data.cloudinit_config.prmthus_service.rendered
  key_name                    = var.key_pair_name  
  lifecycle {
    create_before_destroy = true
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile.name
  }
  
  tags = {
    Name        = "${var.observability_server}-lt"
    Environment = "${var.observability_server}"
  }
}

## Creating Admin AutoScaling Group
resource "aws_autoscaling_group" "autoscaling_group-observability" {
  name                 = "${var.observability_server}-asg"
  launch_template {
    id      = aws_launch_template.launch_template-observability.id
    version = "$Latest"
  }
  min_size             = 1
  desired_capacity     = 1
  max_size             = 2
  target_group_arns    = [aws_lb_target_group.Grafana_target_group.arn,aws_lb_target_group.Promethious_target_group.arn]
  health_check_type    = "ELB"
  vpc_zone_identifier  = [var.private_subnet_id_A]
  
  tag {
    key                 = "Environment"
    value               = "Prod"
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = "${var.observability_server}"
    propagate_at_launch = true
  }
}

data "cloudinit_config" "prmthus_service" {
  part {
    content_type = "text/x-shellscript"
    content      = file("./userdata/prmthus.sh")
  }

  part {
    content_type = "text/cloud-config"
    content = yamlencode({
      write_files = [
        {
          encoding    = "b64"
          content     = filebase64("./userdata/prometheus.service.txt")
          path        = "/etc/systemd/system/prometheus.service"
          owner       = "prometheus:prometheus"
          permissions = "0755"
        },
      ]
    })
  }

  part {
    content_type = "text/x-shellscript"
    content      = file("./userdata/prmthus_start.sh")
  }

  part {
    content_type = "text/x-shellscript"
    content      = file("./userdata/grafana_setup.sh")
  }

}