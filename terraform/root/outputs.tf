# Outputs
output "region" {
  value = var.region
}

output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet" {
  value = module.vpc.public_subnet
}

output "private_subnet" {
  value = module.vpc.private_subnet
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "alb_sg_id" {
  value = module.security_groups.alb_sg_id
}

output "private_sg_id" {
  value = module.security_groups.private_sg_id
}

output "db_sg_id" {
  value = module.security_groups.db_sg_id
}

output "alb_arn" {
  value = module.load_balancer.alb_arn
}

output "target_group_arn" {
  value = module.load_balancer.target_group_arn
}

output "alb_dns_name" {
  value = module.load_balancer.alb_dns_name
}
