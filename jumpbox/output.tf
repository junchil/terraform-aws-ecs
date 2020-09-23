output "elastic_ip" {
  value = aws_eip.ip.public_ip
}

output "jumpbox_sg" {
  value = aws_security_group.kubernetes-server-instance-sg.id
}

