#!/bin/bash

set -e

LAMBDA_FUNCTION_NAME=spring-cloud-function-demo

mvn -DskipTests clean package
docker build -t ${LAMBDA_FUNCTION_NAME}:latest .
