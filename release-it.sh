#!/bin/bash
source .env
GITHUB_TOKEN=$GITHUB_TOKEN PREV_VERSION=$(release-it --no-increment --release-version --ci | tail -1) release-it --only-version "$@"
