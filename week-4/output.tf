output "all_instances_ids" {
  value = concat(module.ec2_instances.public_instances_ids, module.ec2_instances.private_instances_ids)
}