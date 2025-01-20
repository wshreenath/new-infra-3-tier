# Create an EC2 Auto Scaling Group - app
resource "aws_autoscaling_group" "swiggy-app-asg" {
  name                 = "swiggy-app-asg"
  launch_configuration = aws_launch_configuration.swiggy-app-lconfig.id
  vpc_zone_identifier  = [aws_subnet.swiggy-pvt-sub-1.id, aws_subnet.swiggy-pvt-sub-2.id]
  min_size             = 2
  max_size             = 3
  desired_capacity     = 2
}

# Create a launch configuration for the EC2 instances
resource "aws_launch_configuration" "swiggy-app-lconfig" {
  name_prefix                 = "swiggy-app-lconfig"
  image_id                    = "ami-0ed194d7eff6d2f81 "
  instance_type               = "t2.micro"
  key_name                    = "devopsbyraham"
  security_groups             = [aws_security_group.swiggy-ec2-asg-sg-app.id]
  user_data                   = <<-EOF
                                #!/bin/bash

                                sudo yum install mysql -y

                                EOF
                                
  associate_public_ip_address = false
  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}


