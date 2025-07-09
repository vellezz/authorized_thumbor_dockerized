#!/bin/sh
envsubst < /etc/envoy/envoy.yaml.template > /etc/envoy/envoy.yaml
exec envoy -c /etc/envoy/envoy.yaml --log-level debug
