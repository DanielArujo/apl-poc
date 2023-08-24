# Usefull commands aws

    aws --endpoint-url=http://localhost:4566

# Local Stack

    localstack start -d
    localstack stop
    localstack status services

# Terraform

    tflocal init
    tflocal apply --auto-approve
    tflocal destroy

# s3

    awslocal s3 ls
    awslocal s3 ls <bucket_name>

# Lambda

    awslocal lambda list-functions
    awslocal lambda invoke --function-name my-lambda-function --payload='{}' out --log-type Tail
    awslocal lambda invoke --function-name my-lambda-function --payload='{}' output.json

    awslocal logs tail lambda-proxy --follow

    aws lambda add-permission --function-name my-lambda-function --action lambda:InvokeFunction --principal "\*" --statement-id AllowAllAccounts

# SQS

    awslocal sqs receive-message --queue-url https://localhost:4566/000000000000/sample-topic --attribute-names All --message-attribute-names All --max-number-of-messages 10

# Dynamodb

    awslocal dynamodb list-tables --region sa-east-1

    awslocal dynamodb create-table \
    --table-name sample_table \
    --key-schema AttributeName=id,KeyType=HASH AttributeName=coluna,KeyType=RANGE \
    --attribute-definitions AttributeName=id,AttributeType=S AttributeName=coluna,AttributeType=S \
    --billing-mode PAY_PER_REQUEST \
    --region sa-east-1

# IAM

    awslocal iam list-users

# Cloud Watch / Logs

    awslocal logs describe-log-groups
    awslocal logs describe-log-streams --log-group-name /aws/lambda/lambda-proxy

    awslocal logs get-log-events --log-group-name /aws/lambda/lambda-proxy --log-stream-name  "2023/08/21/[\$LATEST]f85b8ceb509ac07fed3b377c29be4209"
    awslocal logs tail --log-group-name /aws/lambda/lambda-proxy --follow
    awslocal logs tail /aws/lambda/user-func --follow

    https:///sjdfzqct5y.execute-api.localhost.localstack.cloud:4566/prod/novo

    https://sjdfzqct5y.execute-api.sa-east-1.amazonaws.com/prod

# Misc

SNS→Lambda Or SNS→SQS→Lambda > https://www.rahulpnath.com/blog/amazon-sns-to-lambda-or-sns-sqs-lambda-dotnet/

SQS Queues and SNS Notifications > Now Best Friends > https://aws.amazon.com/blogs/aws/queues-and-notifications-now-best-friends/

Fanout pattern > https://aws.amazon.com/blogs/compute/messaging-fanout-pattern-for-serverless-architectures-using-amazon-sns/
