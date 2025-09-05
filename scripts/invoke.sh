#!/bin/bash

LAMBDA_FUNCTION_NAME="spring-cloud-function-demo"

# 呼び出し
aws lambda invoke --function-name $LAMBDA_FUNCTION_NAME --payload 'file://payload.json' response.json


# # 最新のログを確認
# aws logs describe-log-groups --log-group-name-prefix
# /aws/lambda/$LAMBDA_FUNCTION_NAME
#
# # ログストリームを確認
# aws logs describe-log-streams \
#   --log-group-name /aws/lambda/$LAMBDA_FUNCTION_NAME \
#   --order-by LastEventTime \
#   --descending
#
# # ログイベントを取得
# aws logs get-log-events \
#   --log-group-name /aws/lambda/$LAMBDA_FUNCTION_NAME \
#   --log-stream-name [LOG_STREAM_NAME]
