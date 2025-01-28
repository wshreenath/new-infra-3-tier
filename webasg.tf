###### Create an EC2 Auto Scaling Group - web ######
resource "aws_autoscaling_group" "swiggy-web-asg" {
  name = "swiggy-web-asg"
  launch_template {
    id      = aws_launch_template.swiggy-web-template.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.swiggy-pub-sub-1.id, aws_subnet.swiggy-pub-sub-2.id]
  min_size            = 2
  max_size            = 3
  desired_capacity    = 2
}

###### Create a Launch Template for the EC2 instances ######
resource "aws_launch_template" "swiggy-web-template" {
  name_prefix   = "swiggy-web-template"
  image_id      = "ami-0ed194d7eff6d2f81"
  instance_type = "t2.micro"
  key_name      = "devopsbyraham"
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.swiggy-ec2-asg-sg.id]
  }
  user_data = base64encode(file("apache.sh"))
  lifecycle {
    prevent_destroy = false
    ignore_changes  = all
  }
}
