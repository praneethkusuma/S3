#!/bin/bash

# Usage: ./push_to_s3.sh your-s3-bucket-name branch-name commit-id

S3_BUCKET=$1
BRANCH_NAME=$2
COMMIT_ID=$3
CLONE_DIR=$4  # Directory where the repository is cloned, e.g., 'qa'

# Sync the contents of the specified directory to the S3 bucket
aws s3 sync $CLONE_DIR s3://$S3_BUCKET/$BRANCH_NAME/$COMMIT_ID/ --delete
echo "All files have been uploaded to S3 under ${BRANCH_NAME}-${COMMIT_ID}/"
