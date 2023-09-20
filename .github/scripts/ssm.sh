#!/bin/bash

CLUSTER_NAME=$(aws ssm get-parameter --name "CLUSTER_NAME" --query "Parameter.Value" --output text)
CLUSTER_NAME=$(aws kms decrypt --ciphertext-blob fileb://<$(echo "$CLUSTER_NAME" | base64 -d) --output text --query Plaintext | base64 -d)

CLUSTER_ROLE_ARN=$(aws ssm get-parameter --name "CLUSTER_ROLE_ARN" --query "Parameter.Value" --output text)
_AWS_ACCESS_KEY_ID=$(aws ssm get-parameter --name "_AWS_ACCESS_KEY_ID" --query "Parameter.Value" --output text)
_AWS_SECRET_ACCESS_KEY=$(aws ssm get-parameter --name "_AWS_SECRET_ACCESS_KEY" --query "Parameter.Value" --output text)
_AWS_REGION=$(aws ssm get-parameter --name "_AWS_REGION" --query "Parameter.Value" --output text)
SOURCE_REPOSITORY=$(aws ssm get-parameter --name "SOURCE_REPOSITORY" --query "Parameter.Value" --output text)
CLUSTER_ROLE_NAME=$(aws ssm get-parameter --name "CLUSTER_ROLE_NAME" --query "Parameter.Value" --output text)
CODEBUILD_ROLE_ARN=$(aws ssm get-parameter --name "CODEBUILD_ROLE_ARN" --query "Parameter.Value" --output text)
DOCKER_USERNAME=$(aws ssm get-parameter --name "DOCKER_USERNAME" --query "Parameter.Value" --output text)
DOCKER_TOKEN=$(aws ssm get-parameter --name "DOCKER_TOKEN" --query "Parameter.Value" --output text)
GITHUB_TOKEN=$(aws ssm get-parameter --name "GITHUB_TOKEN" --query "Parameter.Value" --output text)
JWT_TOKEN=$(aws ssm get-parameter --name "JWT_TOKEN" --query "Parameter.Value" --output text)

aws cloudformation create-stack \
--stack-name cv-cloudformation-stack \
--template-body file://cloudfront-template.yml \
--parameters \
ParameterKey=EksClusterName,ParameterValue=${CLUSTER_NAME} \
ParameterKey=EksClusterRoleArn,ParameterValue=${CLUSTER_ROLE_ARN} \
ParameterKey=AwsAccessKeyId,ParameterValue=${_AWS_ACCESS_KEY_ID} \
ParameterKey=AwsSecretAccessKey,ParameterValue=${_AWS_SECRET_ACCESS_KEY} \
ParameterKey=AwsRegion,ParameterValue=${_AWS_REGION} \
ParameterKey=ClusterRoleName,ParameterValue=${CLUSTER_ROLE_NAME} \
ParameterKey=GitSourceRepo,ParameterValue=${SOURCE_REPOSITORY} \
ParameterKey=CodeBuildRoleArn,ParameterValue=${CODEBUILD_ROLE_ARN} \
ParameterKey=CodePipelineRoleArn,ParameterValue=${CODEPIPELINE_ROLE_ARN} \
ParameterKey=DockerUserName,ParameterValue=${DOCKER_USERNAME} \
ParameterKey=DockerToken,ParameterValue=${DOCKER_TOKEN} \
ParameterKey=GitHubToken,ParameterValue=${GITHUB_TOKEN} \
ParameterKey=GitHubUser,ParameterValue=${GITHUB_USER} \
ParameterKey=JWTToken,ParameterValue=${JWT_TOKEN}