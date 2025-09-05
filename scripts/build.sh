#!/bin/bash

set -e

mvn -DskipTests clean package
docker build -t demo-scf:local .
