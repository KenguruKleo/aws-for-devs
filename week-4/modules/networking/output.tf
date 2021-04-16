output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_id" {
  value = aws_subnet.public_subnet[0].id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnet[0].id
}

output "default_sg_id" {
  value = aws_security_group.default.id
}

output "security_groups_ids" {
  value = [aws_security_group.default.id]
}

output "public_route_table_ids" {
  value = aws_route_table.public.*.id
}
output "private_route_table_ids" {
  value = aws_route_table.private.*.id
}
