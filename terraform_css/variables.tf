
variable "env_prefix" {
    type        = string
    default     = "css" # Prefix used in strings
    description = "Prefix all resources with css to differentiate them."
} 

variable "aws_region" {
    type        = string
    default     = "us-east-1"
    description = "Set region. North Virginia for ease of use."
}

variable "aws_profile" { 
    type        = string
    default     ="kvasilev"
    description = "Profile in cli config."
}

variable "aws_kvasilev_arn" {
    type        = string
    default     = "arn:aws:iam::461126874783:role/ecsTaskExecutionRole"
    description = "Resource name for Fargate so it can write logs."
}

variable "access_key" {
    description = "Holder. Value is in terraform.ftvars."
}
variable "secret_key" {
    description = "Holder. Value is in terraform.ftvar.s"
}

variable "css_vpc_cidr" { 
    type        = string 
    default     = "192.168.0.0/16"
    description = "VPC cidr block"
}

variable "css_app_image" {
    type        = string
    default     = "461126874783.dkr.ecr.us-east-1.amazonaws.com/css_repo"
    description = "Image to use."
}

variable "css_app_cpu" {
    type        = number
    default     = 2048
    description = "Fargate instance CPU units to provision ( 1 vCPU = 1024 CPU units )"
}

variable "css_app_memory" {
    type        = number
    default     = 4096
    description = "Fargate instance memory to provision ( in MiB )"
}

variable "css_app_count" {
    type        = number
    default     = 1
    description = "How many tasks we need running"
}

variable "css_app_health_check_grace_period" {
    type        = number
    default     = 300
    description = "Grace period in seconds for heath check"
}

variable "css_app_log_group" {
    type        = string
    default     = "css-log-group"
    description = "Log group to which to write logs"
}