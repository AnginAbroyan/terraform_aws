module "vpc" {
  source              = "../modules/vpc"
  region              = var.region
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  project_name        = var.project_name
  tags                = var.tags
}


module "security_groups" {
  source = "../modules/security_group"
  vpc_id = module.vpc.vpc_id
  app_port = var.app_port
  project_name = var.project_name
  tags = var.tags
  my_ip = var.my_ip
}

module "load_balancer" {
  source = "../modules/alb"
  vpc_id = module.vpc.vpc_id
  alb_sg_id = module.security_groups.alb_sg_id
  public_subnet_id = module.vpc.public_subnet
  project_name = var.project_name
  tags = var.tags
}

module "launch_template" {
  source = "../modules/launch_template"
  instance_ami = var.instance_ami
  instance_type = var.instance_type
  private_sg_id = module.security_groups.private_sg_id
  instance_keypair = var.instance_keypair
  ecr_repos = var.ecr_repos
  project_name = var.project_name
  tags = var.tags
  user_data_file = "${path.module}/user-data.sh"
}

module "auto_scaling_group" {
  source = "../modules/asg"
  target_group_arn = module.load_balancer.target_group_arn
  private_subnet_id = module.vpc.private_subnet
  project_name = var.project_name
  tags = var.tags
  asg_max_size = var.asg_max_size
  asg_min_size = var.asg_min_size
  asg_desired_capacity = var.asg_desired_capacity
  launch_template_id = module.launch_template.launch_template_id
  launch_template_latest_version = module.launch_template.launch_template_latest_version
}

module "ecr" {
  source     = "../modules/ecr"
  ecr_repos  = var.ecr_repos
  project_name = var.project_name
}


