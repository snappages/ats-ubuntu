#!/bin/bash

if [ -d "/opt/deploy/ats/config" ]; then
  cp /opt/deploy/ats/config/* /etc/trafficserver/
  chown -R nobody:nogroup /etc/trafficserver
fi

exec "$@"
