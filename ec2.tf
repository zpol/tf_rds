resource "aws_instance" "frontend" {

  launch_template {
    id = aws_launch_template.main.id
  }
  credit_specification {
    cpu_credits = "unlimited"
  }

}

resource "aws_iam_instance_profile" "main" {
  name = "main"
  role = "ml-demo-meetup"
  tags = {
    Name = "main"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "TLS from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

ingress {
    description      = "Allow SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_launch_template" "main" {
  name = "demo-frontend"
  image_id = "ami-00f7e5c52c0f43726" 
  key_name = "ml-demo-meetup"
  ebs_optimized = false
  instance_type = "t3.micro"
  user_data = base64encode(templatefile("./templates/cloud_init.tpl", { role = "admin" }) )
  
  monitoring {
    enabled = false
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination = true
    device_index = 0
    subnet_id = module.vpc.public_subnets[0]
    security_groups = [ aws_security_group.allow_tls.id ]
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.main.arn
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      encrypted   = false
      volume_size = 8
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "main"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "main"
  }
}


output "frontend_ip" {
  value = aws_instance.frontend.public_ip
}