#!/bin/bash

podman build -t youmoni/kura-docker-arm64:1.0.1 .

podman save -o /tmp/kura-docker-arm64-1.0.1.tar youmoni/kura-docker-arm64:1.0.1
