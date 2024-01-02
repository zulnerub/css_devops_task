
variable "env_prefix" {
    type    = string
    default = "css" # Prefix used in strings
} 

variable "aws_region" {
    type    = string
    default = "us-east-1" # North Virginia
}
variable "aws_profile" { 
    default ="kvasilev" # IAM account
}
variable "aws_kvasilev_arn" {
    type    = string
    default = "arn:aws:iam::461126874783:role/ecsTaskExecutionRole"
    #default = "arn:aws:iam::461126874783:user/kvasilev"
}
variable "access_key" {
    description = "Access key to AWS console"
}
variable "secret_key" {
    description = "Secret key to AWS console"
}

variable "css_vpc_cidr" { 
    type    = string 
    default = "192.168.0.0/16"
}

variable "css_app_image" {
    type    = string
    default = "461126874783.dkr.ecr.us-east-1.amazonaws.com/css_repo"
}

# Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)
variable "css_app_cpu" { default = 2048 }

# Fargate instance memory to provision ( in MiB)
variable "css_app_memory" { default = 4096 }

variable "css_app_count" { default = 1 }
# Grace period in seconds:
variable "css_app_health_check_grace_period" { default = 300 }

variable "css_app_log_group" {
    default = "css-log-group"
}