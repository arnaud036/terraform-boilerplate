variable "prefix" {
    type       = string
    description = "Prefix for resources creation"
}

variable "docker_image" {
    type        = string
    description = "The Docker image"
}

variable "docker_tag" {
    type        = string
    description = "The Docker tag"
    default     = "latest"
}

variable "container_cpu" {
    type    = number  
    default = 256
}

variable "container_memory" {
    type    = number  
    default = 512
}

variable "container_port" {
    type    = number  
    default = 80
}

variable "container_environment" {
  type = list(object({
    name = string
    value = string
  }))
  default = [ ]
}

variable "aws_region" {
    type        = string
    description = "The AWS region"
    default     = "us-east-1"
}

variable "vpc_id" {
    type        = string
    description = "The VPC ID"
}

variable "subnet_ids" {
    type        = list(string)
    description = "The subnet IDs"
}
