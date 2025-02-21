#!/bin/sh

echo "## this fails 'not authorised.'"
docker run --rm --network=host eclipse-mosquitto:2.0.20 mosquitto_sub -t test -v -t "#"

echo "## this successfully listens"
docker run --rm --network=host eclipse-mosquitto:2.0.20 mosquitto_sub -t test -v -t "#" -u joe --pw pwdjoe1
