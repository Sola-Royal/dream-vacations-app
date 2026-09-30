#!/usr/bin/env bash
set -euo pipefail

BUCKET_NAME="dream-vacations-capstone-tfstate"
LOCK_TABLE="dream-vacations-capstone-tf-locks"
REGION="eu-north-1"

echo "Checking for existing state bucket '$BUCKET_NAME'..."
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "Bucket already exists, skipping creation."
else
  aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$REGION" \
    --create-bucket-configuration LocationConstraint="$REGION"
  aws s3api put-bucket-versioning --bucket "$BUCKET_NAME" --versioning-configuration Status=Enabled
  aws s3api put-bucket-encryption --bucket "$BUCKET_NAME" --server-side-encryption-configuration '{
    "Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]
  }'
  aws s3api put-public-access-block --bucket "$BUCKET_NAME" --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
  echo "Bucket '$BUCKET_NAME' created."
fi

echo "Checking for existing lock table '$LOCK_TABLE'..."
if aws dynamodb describe-table --table-name "$LOCK_TABLE" --region "$REGION" >/dev/null 2>&1; then
  echo "Lock table already exists, skipping creation."
else
  aws dynamodb create-table \
    --table-name "$LOCK_TABLE" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region "$REGION"
  aws dynamodb wait table-exists --table-name "$LOCK_TABLE" --region "$REGION"
  echo "Lock table '$LOCK_TABLE' is ready."
fi
