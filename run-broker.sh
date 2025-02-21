#!/bin/sh

set -e

docker build -t broker .
docker rm -f broker || true
docker run --rm --publish 1883:1883 broker
