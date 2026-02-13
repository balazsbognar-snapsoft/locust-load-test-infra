output "instance_id" {
  value       = aws_instance.this.id
  description = "ID of the EC2 instance"
}

output "private_ip" {
  description = "The private ip of the jumpbox"
  value       = aws_instance.this.private_ip
}
output "selected_ami" {
  description = "The ami name that is used for the jumpbox"
  value       = lookup(local.read_amis, var.ami_id, { name = "unkown" }).name
}

output "security_group_id" {
  value = aws_security_group.this.id
}

output "instance_iam_role" {
  value = aws_iam_role.this[0].name
}
