output "ec2_instance_ip_address_1" {
  description = "The address of the EC2 instance 1"
  value       = aws_instance.webserver1.public_ip
}

output "ec2_instance_ip_address_2" {
  description = "The address of the EC2 instance 2"
  value       = aws_instance.webserver2.public_ip
}
