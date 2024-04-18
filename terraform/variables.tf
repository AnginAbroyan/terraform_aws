variable "region" {
  default = "eu-central-1"  # Frankfurt
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = [
    "10.0.0.0/24",
    "10.0.36.0/24",
  ]
}

variable "private_subnet_cidrs" {
  default = [
    "10.0.64.0/24"
  ]
}

variable "project_name" {
  default = "Brainscale-simple_app"
}


variable "tags" {
  default = {
    Project = "Terraform_Brainscale"
  }
}


variable "instance_type" {
  default = "t2.micro"
}

variable "instance_ami" {
  default = "ami-04f9a173520f395dd"
}


#ASG
variable "asg_max_size" {
  default = "2"
}
variable "asg_min_size" {
  default = "2"
}
variable "asg_desired_capacity" {
  default = "2"
}


#ECR

variable "ecr_repos"{
  description = "List of repo names"
  default = ["ecr-brainscale"]
}
variable "dockerfile_location" {
  default = "/home/kali/Desktop/terraform_brainscale"
}

variable "instance_keypair" {
  description = "AWS EC2 Key pair"
  type        = string
  default     = "brainscale"
}
