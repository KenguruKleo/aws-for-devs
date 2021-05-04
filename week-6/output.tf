output "elb_dns_name" {
  value = module.elb_http.this_elb_dns_name
}

output "public_IDs" {
  value = module.ec2_instances.public_instances_ids
}
