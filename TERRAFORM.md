# Terraform運用ガイド

Spring Cloud FunctionアプリケーションをAWS LambdaにデプロイするためのTerraform設定です。

## 構成

- **VPC**: プライベートサブネット2つを含むVPC
- **Lambda**: VPC内で実行されるSpring Cloud Function
- **IAM Role**: CloudWatch Logsアクセス権限を持つLambda実行ロール

## 前提条件

1. AWS CLIの設定（認証情報の設定）
2. Terraformのインストール（v1.0以上推奨）
3. Javaアプリケーションのビルド済みJARファイル

## セットアップ手順

### 1. アプリケーションのビルドとDockerイメージの作成

```bash
# アプリケーションのビルド
mvn clean package

# Dockerイメージのビルド
docker build -t spring-cloud-function-demo .
```

### 2. Terraformの初期化

```bash
cd terraform
terraform init
```

### 3. 設定の確認

`terraform/variables.tf`で以下の設定を必要に応じて変更：

- `aws_region`: AWSリージョン（デフォルト: ap-northeast-1）
- `project_name`: プロジェクト名（リソース命名に使用）
- `lambda_jar_path`: JARファイルのパス
- `lambda_function_name`: Lambda関数名

### 4. ECRへのDockerイメージプッシュ

```bash
# Terraformでインフラをデプロイしてから実行
terraform apply

# ECR にログイン
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin $(terraform output -raw ecr_repository_url | cut -d'/' -f1)

# イメージにタグ付け
docker tag spring-cloud-function-demo:latest $(terraform output -raw ecr_repository_url):latest

# ECRにプッシュ
docker push $(terraform output -raw ecr_repository_url):latest

# Lambda関数のコードを更新
aws lambda update-function-code --function-name spring-cloud-function-demo --image-uri $(terraform output -raw ecr_repository_url):latest
```

## Lambda関数のテスト

### AWS CLIでのテスト

```bash
# greet関数のテスト（JSON入力）
aws lambda invoke \
  --function-name spring-cloud-function-demo \
  --payload '{"name": "Terraform"}' \
  output.json

# 結果の確認
cat output.json
```

### AWSコンソールでのテスト

1. AWS Lambda コンソールを開く
2. 関数名 `spring-cloud-function-demo` を選択
3. 「テスト」タブでテストイベントを作成：
   ```json
   {
     "name": "World"
   }
   ```
4. 「テスト」ボタンをクリックして実行

期待される出力：

```json
{
  "message": "Hello, World!",
  "timestamp": "2024-XX-XXTXX:XX:XX.XXXZ"
}
```

## ログの確認

```bash
# CloudWatch Logsでログを確認
aws logs tail /aws/lambda/spring-cloud-function-demo --follow
```

## リソースの削除

```bash
terraform destroy
```

確認メッセージで `yes` を入力してリソースを削除します。

## トラブルシューティング

### よくある問題

1. **Dockerイメージがビルドできない**

   - `mvn clean package`でビルドが完了していることを確認
   - Dockerfileが正しい場所にあることを確認

2. **Lambda関数の起動が遅い**

   - コンテナイメージのコールドスタート時間は通常5-15秒
   - メモリサイズを増やすことで改善される場合があります
   - イメージサイズを最適化することで起動時間を短縮できます

3. **VPCタイムアウト**
   - NAT Gatewayが正しく設定されていることを確認
   - セキュリティグループの設定を確認

### ログの確認方法

```bash
# Terraform操作ログ
export TF_LOG=DEBUG
terraform apply

# AWSリソースのログ
aws logs describe-log-groups --log-group-name-prefix "/aws/lambda/"
```

## 設定のカスタマイズ

### メモリとタイムアウトの調整

`terraform/variables.tf`で以下を変更：

```hcl
variable "lambda_memory_size" {
  default = 1024  # メモリを増やす
}

variable "lambda_timeout" {
  default = 60    # タイムアウトを延長
}
```

### 環境変数の追加

`terraform/lambda.tf`の`environment`ブロックに追加：

```hcl
environment {
  variables = {
    MAIN_CLASS = "com.example.demo.App"
    spring_cloud_function_definition = "greet"
    CUSTOM_ENV_VAR = "custom_value"
  }
}
```

## セキュリティ考慮事項

- Lambda関数はVPCのプライベートサブネット内で実行
- インターネットアクセスはNAT Gateway経由
- IAMロールは最小権限の原則に従い、CloudWatch Logsアクセスのみ許可
- セキュリティグループは必要最小限の通信のみ許可
