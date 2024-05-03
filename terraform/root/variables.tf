variable "region" {
  default = "eu-central-1"  # Frankfurt
}

#VPC
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = [
    "10.0.0.0/24",
    "10.0.36.0/24",
  ]
}

variable "private_subnet_cidr" {
  default = [
    "10.0.64.0/24"
  ]
}

#Project
variable "project_name" {
  default = "Brainscale-simple_app"
}


variable "tags" {
  default = {
    Project = "Terraform_Brainscale"
  }
}

#Launch template
variable "instance_keypair" {
  description = "AWS EC2 Key pair"
  type        = string
  default     = "brainscale"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_ami" {
  default = "ami-023adaba598e661ac"
}


#ASG
variable "asg_max_size" {
  default = "1"
}
variable "asg_min_size" {
  default = "1"
}
variable "asg_desired_capacity" {
  default = "1"
}


#ECR

variable "ecr_repos" {
  description = "List of repo names"
  default     = ["ecr-brainscale"]
}


#SG
variable "app_port" {
  default = 3000
}

variable "my_ip" {
  default = ["91.103.248.27/32"]
}