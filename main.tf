#Get Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical

}

# Create a VPC
resource "aws_vpc" "VPC_BOOTCAMP1" {
  cidr_block = "10.1.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "VPC_BOOTCAMP1"
  }
}

# Public subnet 
resource "aws_subnet" "PUBLIC_SUBNET" {
  vpc_id                  = aws_vpc.VPC_BOOTCAMP1.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = var.AZ1
  map_public_ip_on_launch = true  

  tags = {
    Name = "Public_Subnet"
  }
}

# Internet gateway for public subnet
resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.VPC_BOOTCAMP1.id

  tags = {
    Name = "Internet_Gateway"
  }
}

# routing table for VPC
resource "aws_route_table" "ROUTE_TABLE" {
  vpc_id = aws_vpc.VPC_BOOTCAMP1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }

  tags = {
    Name = "Routing_Table"
  }
}

# Assign Public_Subnet to routing table
resource "aws_route_table_association" "RT_PUBLIC" {
  subnet_id      = aws_subnet.PUBLIC_SUBNET.id
  route_table_id = aws_route_table.ROUTE_TABLE.id
}

# Security group allow WebServer Public Access (22)
resource "aws_security_group" "SERVER_ACCESS" {
  name        = "Allow SERVER_ACCESS"
  description = "Allow 22 inbound traffic"
  vpc_id      = aws_vpc.VPC_BOOTCAMP1.id

  ingress {
    description      = "SSH ACCESS"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]    
  }  

  tags = {
    Name = "SG_Public_Access"
  }
}

#Create Role 
resource "aws_iam_role" "SSMtoSNS" {
  name = "SSMtoSNS"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ssm.amazonaws.com"
        }
      },
    ]
  })
}

#Assign policy to role (SSM full access to SNS)
resource "aws_iam_role_policy_attachment" "SNSFullAccess" {
    role = aws_iam_role.SSMtoSNS.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

resource "aws_sns_topic" "DevOpsNotification" {
  name = "DevOpsNotification"
}

resource "aws_sns_topic_subscription" "SSM_Alerts" {
  topic_arn = aws_sns_topic.DevOpsNotification.arn
  protocol  = "email"
  endpoint  = var.EMAIL
}

#Create EC2 instante 1
resource "aws_instance" "webserver1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = var.KEY
  subnet_id = aws_subnet.PUBLIC_SUBNET.id
  vpc_security_group_ids = [aws_security_group.SERVER_ACCESS.id]
  associate_public_ip_address = true

  tags = {
    Name = "webserver1"
  }
}

#Create EC2 instante
resource "aws_instance" "webserver2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = var.KEY
  subnet_id = aws_subnet.PUBLIC_SUBNET.id
  vpc_security_group_ids = [aws_security_group.SERVER_ACCESS.id]
  associate_public_ip_address = true

  tags = {
    Name = "webserver2"
  }
}