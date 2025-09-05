#!/bin/bash

curl -X POST http://localhost:9000/2015-03-31/functions/function/invocations \
  -H "Content-Type: application/json" \
  -d '{"headers":{"pgmid":"greet"},"payload":{"name":"Alice"}}'
