variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "spring-cloud-function-demo"
}

variable "image_tag" {
  description = "Docker image tag for Lambda container"
  type        = string
  default     = "latest"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "spring-cloud-function-demo"
}

variable "lambda_memory_size" {
  description = "Memory size for Lambda function"
  type        = number
  default     = 512
}

variable "lambda_timeout" {
  description = "Timeout for Lambda function in seconds"
  type        = number
  default     = 30
}
