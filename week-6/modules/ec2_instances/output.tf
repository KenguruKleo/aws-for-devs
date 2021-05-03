output "public_instances_ids" {
  value = aws_instance.PublicInstance.*.id
}

output "private_instances_ids" {
  value = aws_instance.PrivateInstance.*.id
}
