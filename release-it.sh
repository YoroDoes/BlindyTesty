#!/bin/bash
source .env
GITHUB_TOKEN=$GITHUB_TOKEN release-it "$@"
