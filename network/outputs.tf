output "instance_private_ec2_id" {
  value = {
    for k, instance in aws_instance.bakend_ec2 : k => instance.id
  }
}

output "public_subnet_id" {
  value = {
    for k, subnet in aws_subnet.public_subnet : k => subnet.id
  }
}

output "private_subnet_id" {
  value = {
    for k, subnet in aws_subnet.private_subnet : k => subnet.id
  }
}

output "nat_gateway_id" {
  value = aws_nat_gateway.my_nat_gateway.id
}

output "private_sg_id" {
  value = aws_security_group.private_sg.id
}