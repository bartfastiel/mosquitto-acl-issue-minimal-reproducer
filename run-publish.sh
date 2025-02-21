#!/bin/sh

echo "## this fails silently"
docker run --rm --network=host eclipse-mosquitto:2.0.20 mosquitto_pub -t forbidden -m hi --debug -u joe --pw pwdjoe1 && echo exit code $?

echo "## this works as expected (matches the allowed topic)"
docker run --rm --network=host eclipse-mosquitto:2.0.20 mosquitto_pub -t allowed   -m hi --debug -u joe --pw pwdjoe1 && echo exit code $?
