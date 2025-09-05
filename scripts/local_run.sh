#!/bin/bash

set -e

docker run --rm -p 9000:8080 spring-cloud-function-demo:latest
