#!/usr/bin/env bash

export AWS_ACCESS_KEY_ID="access_key"
export AWS_SECRET_ACCESS_KEY="secret_key"
export AWS_DEFAULT_REGION="us-east-1"

readonly endpoint_url="http://localhost:9000"
readonly bucket="bucket1"

echo "Generating test file..."
dd if=/dev/zero of=zeros-1m.txt count=1 bs=1048576

echo "== Starting all nodes (write quorum) =="
mkdir -p data/node{1..4}
docker-compose down
docker-compose up -d
timeout 60 bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' http://localhost:9000)" != "403" ]]; do sleep 5; done'
echo -e "\n>> successful bucket creation..." 
aws s3 mb --endpoint-url ${endpoint_url} s3://${bucket}
echo -e "\n>> successful bucket listing..." 
aws s3 ls --endpoint-url ${endpoint_url} s3://
echo -e "\n>> successful write..." 
time aws s3 cp --endpoint-url ${endpoint_url} zeros-1m.txt s3://${bucket}/zeros-1m-1.txt
echo -e "\n>> successful read..."
time aws s3 cp --endpoint-url ${endpoint_url} s3://${bucket}/zeros-1m-1.txt .
echo -e "====\n\n"

echo "== Stopping node 4 (n/2+1 remaining: write quorum) =="
docker stop minio-cluster_node4_1
echo -e "\n>> successful write..." 
time aws s3 cp --endpoint-url ${endpoint_url} zeros-1m.txt s3://${bucket}/zeros-1m-2.txt
echo -e "\n>> successful read..."
time aws s3 cp --endpoint-url ${endpoint_url} s3://${bucket}/zeros-1m-2.txt .
echo -e "====\n\n"

echo "== Stopping node 3 (n/2 remaining: read quorum) =="
docker stop minio-cluster_node3_1
echo -e "\n>> failed write..." 
time aws s3 cp --endpoint-url ${endpoint_url} zeros-1m.txt s3://${bucket}/zeros-1m-3.txt
echo -e "\n>> successful read..."
time aws s3 cp --endpoint-url ${endpoint_url} s3://${bucket}/zeros-1m-2.txt ./zeros-1m-2-2.txt
echo -e "====\n\n"

echo "== Stopping node 2 (n/2-1 remaining: failed cluster) =="
docker stop minio-cluster_node2_1
echo -e "\n>> failed write..." 
time aws s3 cp --endpoint-url ${endpoint_url} zeros-1m.txt s3://${bucket}/zeros-1m-4.txt
echo -e "\n>> failed read..."
time aws s3 cp --endpoint-url ${endpoint_url} s3://${bucket}/zeros-1m-2.txt ./zeros-1m-2-3.txt
echo -e "====\n\n"

echo "== Restarting all cluster nodes (write quorum) =="
docker-compose down
docker-compose up -d
timeout 60 bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' http://localhost:9000)" != "403" ]]; do sleep 5; done'
echo -e "\n>> successful write..." 
time aws s3 cp --endpoint-url ${endpoint_url} zeros-1m.txt s3://${bucket}/zeros-1m-5.txt
echo -e "\n>> successful read..."
time aws s3 cp --endpoint-url ${endpoint_url} s3://${bucket}/zeros-1m-5.txt .
echo -e "====\n\n"
