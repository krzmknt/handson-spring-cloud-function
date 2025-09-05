# ECR Repository for Lambda container
resource "aws_ecr_repository" "lambda_repo" {
  name = "${var.project_name}-lambda"

  tags = {
    Name = "${var.project_name}-lambda-repo"
  }
}

# Lambda function with container image
resource "aws_lambda_function" "spring_cloud_function" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_execution_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lambda_repo.repository_url}:${var.image_tag}"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout

  # VPC Configuration
  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.lambda.id]
  }

  # Environment variables for Spring Cloud Function
  # environment {
  #   variables = {
  #   }
  # }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_vpc_access,
    aws_iam_role_policy.lambda_logs_policy,
    aws_cloudwatch_log_group.lambda_logs
  ]

  tags = {
    Name = var.lambda_function_name
  }
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14

  tags = {
    Name = "${var.project_name}-lambda-logs"
  }
}
