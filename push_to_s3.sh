#!/bin/bash

# Usage: ./push_to_s3.sh your-s3-bucket-name branch-name commit-id

S3_BUCKET=$1
BRANCH_NAME=$2
COMMIT_ID=$3
S3_DESTINATION="s3://${S3_BUCKET}/${BRANCH_NAME}-${COMMIT_ID}/"

# Sync the local directory to the S3 destination
aws s3 cp ./ "${S3_DESTINATION}" --recursive

echo "All files have been uploaded to S3 under ${BRANCH_NAME}-${COMMIT_ID}/"
