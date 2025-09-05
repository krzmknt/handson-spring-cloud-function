#!/bin/bash

# あらかじめawsへの認証を通しておく必要がある。

ECR_REPO_URL=$(terraform output -raw ecr_repository_url)
LAMBDA_FUNCTION_NAME=spring-cloud-function-demo

# ECR にログイン
aws ecr get-login-password --region ap-northeast-1 | \
  docker login --username AWS \
  --password-stdin $(terraform output -raw ecr_repository_url | cut -d'/' -f1)

# イメージにタグ付け
docker tag ${LAMBDA_FUNCTION_NAME}:latest ${ECR_REPO_URL}:latest

# ECRにプッシュ
docker push ${ECR_REPO_URL}:latest

# Lambda関数のコードを更新
aws lambda update-function-code \
  --function-name ${LAMBDA_FUNCTION_NAME} \
  --image-uri ${ECR_REPO_URL}:latest

