/*_________VPC _________*/
resource "aws_vpc" "mainvpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

/*_________SUBNETS_________*/
resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = var.subnets_cidr[0]
  availability_zone = var.az1
  tags = {
    Name = "public-subnet1"
    # "${var.vpc_name}-public_subnet1" (this syntax will add vpc name before subnet name)
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = var.subnets_cidr[1]
  availability_zone = var.az2
  tags = {
    Name = "public-subnet2"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = var.subnets_cidr[2]
  availability_zone = var.az1
  tags = {
    Name = "private-subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = var.subnets_cidr[3]
availability_zone = var.az2
  tags = {
    Name = "private_subnet2"
  }
}
/*_________Routetables_________*/
resource "aws_route_table" "pulic-route" {
  vpc_id = aws_vpc.mainvpc.id
  tags = {
    Name = "public-route"
  }
}
resource "aws_route" "igw-route" {
  route_table_id            = aws_route_table.public-route.id
  destination_cidr_block    = var.cidr_from_anywhere
  gateway_id = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" "first" {
  subnet_id      = aws_subnet.public_subnet_id2.id
  route_table_id = aws_route_table.public-route.id
}
resource "aws_route_table_association" "second" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_route_table" "privite-route" {
  vpc_id = aws_vpc.mainvpc.id
  tags = {
    Name = "private-route"
  }

}
resource "aws_route" "natgw-route" {
  route_table_id            = aws_route_table.private-route.id
  destination_cidr_block    = var.cidr_from_anywhere
  gateway_id = aws_nat_gateway.nat-gw.id
}
resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private-route.id
}
resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private-route.id
}
/*_______internetgateway_______natgateway_______*/
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mainvpc.id
  tags = {
    Name = "paula-igw"
  }
}
/*_________________________________________________*/
resource "aws_eip" "eip" {
    vpc = true
}
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "1st-natway"
  }

  depends_on = [aws_internet_gateway.igw]
}
/*_________security_groups_________*/
resource "aws_security_group" "secgroup" {
  description = "Allow HTTP traffic from anywhere"
  vpc_id = aws_vpc.mainvpc.id
  tags = {
    Name = "secgroup"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_from_anywhere]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_from_anywhere]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_from_anywhere]
  }
}
/*_________PublicLoadbalancer_________*/
resource "aws_lb" "public-lb" {
  name               = "pub-lb"
  internal           = false
  load_balancer_type = "application"
   ip_address_type = "ipv4"
  security_groups    = [aws_security_group.secgroup.id]
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  # tags = {
  #   Name = "public-lb"
  # }
}
resource "aws_lb_target_group" "publicgroup" {
  name     = "pub-targetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.mainvpc.id
  # tags = {
  #   Name = "public-targetgroup"
  # }
}
resource "aws_lb_target_group_attachment" "attach-proxy1" {
  target_group_arn = aws_lb_target_group.publicgroup.arn
  target_id        = var.publicvmid1
  port             = 80
}
resource "aws_lb_target_group_attachment" "attach-proxy2" {
  target_group_arn = aws_lb_target_group.pub-targetGroup.arn
  target_id        = var.publicvmid2
  port             = 80
}
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.public-lb.arn
  protocol          = "HTTP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.publicgroup.arn
  }
}
/*_________PrivateLoadbalancer_________*/
resource "aws_lb" "private-lb" {
  name               = "priv-lb"
  internal           = true
  ip_address_type = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_groups.id]
  subnets            = [aws_subnet.mysubnet3.id, aws_subnet.private_subnet1.id]
  # tags = {
  #   Name = "private-lb"
  # }
}
resource "aws_lb_target_group" "privategroup" {
  name     = "priv-targetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.mainvpc.id
  # tags = {
  #   Name = "private-targetgroup"
  # }
}
resource "aws_lb_target_group_attachment" "attach-priv1" {
  target_group_arn = aws_lb_target_group.privategroup.arn
  target_id        = var.privatevmid1
  port             = 80
}
resource "aws_lb_target_group_attachment" "attach-priv2" {
  target_group_arn = aws_lb_target_group.privategroup.arn
  target_id        = var.privatevmid2
  port             = 80
}
resource "aws_lb_listener" "listener1" {
  load_balancer_arn = aws_lb.private-lb.arn
  protocol          = "HTTP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.privategroup.arn
  }
}
