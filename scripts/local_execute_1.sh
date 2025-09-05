#!/bin/bash

curl -X POST http://localhost:9000/2015-03-31/functions/function/invocations \
  -H "Content-Type: application/json" \
  -d '{"headers":{"spring.cloud.function.definition":"greet"},"payload":{"name":"Alice"}}'
