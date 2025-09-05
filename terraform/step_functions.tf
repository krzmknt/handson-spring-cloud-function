# IAM Role for Step Functions
resource "aws_iam_role" "step_functions_role" {
  name = "${var.project_name}-step-functions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-step-functions-role"
  }
}

# IAM Policy for Step Functions to invoke Lambda
resource "aws_iam_role_policy" "step_functions_lambda_policy" {
  name = "${var.project_name}-step-functions-lambda-policy"
  role = aws_iam_role.step_functions_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = aws_lambda_function.spring_cloud_function.arn
      }
    ]
  })
}

# Step Functions State Machine
resource "aws_sfn_state_machine" "parallel_lambda_execution" {
  name     = "${var.project_name}-parallel-execution"
  role_arn = aws_iam_role.step_functions_role.arn

  definition = templatefile("${path.module}/step_functions_definition.json", {
    lambda_function_arn = aws_lambda_function.spring_cloud_function.arn
  })

  tags = {
    Name = "${var.project_name}-step-functions"
  }
}