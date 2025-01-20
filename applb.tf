# Create Load balancer - web tier
resource "aws_lb" "swiggy-web-lb" {
  name               = "swiggy-web-lb"
  internal           = true
  load_balancer_type = "application"
  
  security_groups    = [aws_security_group.swiggy-alb-sg-1.id]
  subnets            = [aws_subnet.swiggy-pub-sub-1.id, aws_subnet.swiggy-pub-sub-2.id]

  tags = {
    Environment = "swiggy-web-lb"
  }
}

# create load balancer larget group - web tier

resource "aws_lb_target_group" "swiggy-web-lb-tg" {
  name     = "swiggy-web-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.swiggy-vpc.id

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Create Load Balancer listener - web tier
resource "aws_lb_listener" "swiggy-web-lb-listner" {
  load_balancer_arn = aws_lb.swiggy-web-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.swiggy-web-lb-tg.arn
  }
}

# Register the instances with the target group - web tier
resource "aws_autoscaling_attachment" "swiggy-web-asattach" {
  autoscaling_group_name = aws_autoscaling_group.swiggy-web-asg.name
  alb_target_group_arn   = lb_target_group_arn
  
}

