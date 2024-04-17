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
  default = "ami-023adaba598e661ac"  # Ubuntu20.04
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