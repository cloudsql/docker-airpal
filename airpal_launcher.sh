#!/bin/bash
set -e

AIRPAL_HOME=/opt/airpal

if [ -z "$PRESTO_COORDINATOR" ]; then
  PRESTO_COORDINATOR=http://localhost:8080
fi

exec java -server \
     -Duser.timezone=UTC \
     -Ddw.prestoCoordinator=${PRESTO_COORDINATOR} \
     -cp ${AIRPAL_HOME}/airpal-*-all.jar \
     com.airbnb.airpal.AirpalApplication server ${AIRPAL_HOME}/reference.yml
