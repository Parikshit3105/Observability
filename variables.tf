# variables.tf

variable "observability_server" {
  type = string
  description = "Name of the resources" 
}

variable "region" {
  description = "AWS region"
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  description = "Type of EC2 instance"
}

variable "private_subnet_id_A" {
  description = "Subnet ID for EC2 instance"
}

variable "public_subnit_id_A" {
  description = "Subnet ID for EC2 instance"
}

variable "public_subnit_id_B" {
  description = "Subnet ID for EC2 instance"
}

variable "public_subnit_id_C" {
  description = "Subnet ID for EC2 instance"
}

variable "vpc_id" {
  description = "VPC ID for EC2 instance"
}

variable "vpc_cidr" {
  description = "CIDR range for the VPC"
}


#variable "iam_instance_profile_arn" {
 # description = "IAM instance profile ARN"
#}

variable "key_pair_name" {
  description = "Name of the key pair to be used"
  type        = string
}

variable "environment_name" {
  description = "Key of the tag to extract"
  type        = string
}