output "api_url" {
  value = "${module.api.base_url}"
}

output "vpc_id" {
  value = "${module.vpc_subnets.vpc_id}"
}

#output "nat_subnet_id" {
#  value = "${module.vpc_subnets.nat_subnet_id}"
#}

#output "public_subnet_ids" {
#  value = "${module.vpc_subnets.public_subnet_ids}"
#}

