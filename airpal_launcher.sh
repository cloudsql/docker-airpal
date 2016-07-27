#!/bin/bash
set -e
AIRPAL_HOME=/opt/airpal
#PRESTO_COORDINATOR=http://localhost:8080
PRESTO_COORDINATOR=http://presto:${PRESTO_PORT_8080_TCP_PORT}
exec java -server \
     -Duser.timezone=UTC \
     -Ddw.prestoCoordinator=${PRESTO_COORDINATOR} \
     -cp ${AIRPAL_HOME}/airpal-*-all.jar \
     com.airbnb.airpal.AirpalApplication server ${AIRPAL_HOME}/reference.yml
