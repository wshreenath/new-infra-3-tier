######### Create an EC2 Auto Scaling Group - web ############
resource "aws_autoscaling_group" "swiggy-web-asg" {
  name                 = "swiggy-web-asg"
  launch_configuration = aws_launch_configuration.swiggy-web-lconfig.id
  vpc_zone_identifier  = [aws_subnet.swiggy-pub-sub-1.id, aws_subnet.swiggy-pub-sub-2.id]
  min_size             = 2
  max_size             = 3
  desired_capacity     = 2
}

###### Create a launch configuration for the EC2 instances #####
resource "aws_launch_configuration" "swiggy-web-lconfig" {
  name_prefix                 = "swiggy-web-lconfig"
  image_id                    = "ami-0ed194d7eff6d2f81"
  instance_type               = "t2.micro"
  key_name                    = "devopsbyraham"
  security_groups             = [aws_security_group.swiggy-ec2-asg-sg.id]
  user_data                   = "${file("apache.sh")}"                                
  associate_public_ip_address = true
  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

