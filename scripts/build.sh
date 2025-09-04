#!/bin/bash

mvn -DskipTests clean package
docker build -t demo-scf:local .
