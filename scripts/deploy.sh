#!/bin/bash

set -e

# あらかじめawsへの認証を通しておく必要がある。

LAMBDA_FUNCTION_NAME=spring-cloud-function-demo
ECR_REPO_URL=310682748446.dkr.ecr.ap-northeast-1.amazonaws.com/spring-cloud-function-demo-lambda

# ECR にログイン
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin $(echo $ECR_REPO_URL | cut -d'/' -f1)

# イメージにタグ付け
docker tag ${LAMBDA_FUNCTION_NAME}:latest ${ECR_REPO_URL}:latest

# ECRにプッシュ
docker push ${ECR_REPO_URL}:latest

# Lambda関数のコードを更新
aws lambda update-function-code \
  --function-name ${LAMBDA_FUNCTION_NAME} \
  --image-uri ${ECR_REPO_URL}:latest

