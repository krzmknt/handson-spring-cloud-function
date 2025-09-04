#!/bin/bash

docker run --rm -p 9000:8080 \
  -e SPRING_CLOUD_FUNCTION_DEFINITION=upper \
  demo-scf:local
