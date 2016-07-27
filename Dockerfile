FROM java:8

# Airpal
ENV AIRPAL_COMMIT 550ad14a589a41c95a7a82d14560f3995c419188
ENV AIRPAL_HOME /opt/airpal
WORKDIR $AIRPAL_HOME

RUN set -x \
  && apt-get update && apt-get install -y make g++ \
  && export BUILD_DIR=$(mktemp -d) && cd "${BUILD_DIR}" \
  && git clone https://github.com/airbnb/airpal \
  && cd airpal && git checkout "${AIRPAL_COMMIT}" \
  && ./gradlew clean shadowJar \
  && mkdir -p ${AIRPAL_HOME} \
  && cp build/libs/airpal-*-all.jar $AIRPAL_HOME \
  && cd "${HOME}" && rm -rf .npm .gradle .node-gyp \
  && rm -rf "${BUILD_DIR}" \
  && apt-get purge --auto-remove -y make g++ \
  && apt-get clean

ADD config/reference.h2.yml $AIRPAL_HOME/reference.yml
ADD airpal_launcher.sh $AIRPAL_HOME/launcher
RUN chmod +x $AIRPAL_HOME/launcher

RUN set -x \
  && java -Duser.timezone=UTC -cp ${AIRPAL_HOME}/airpal-*-all.jar \
  com.airbnb.airpal.AirpalApplication db migrate ${AIRPAL_HOME}/reference.yml

EXPOSE 8081 8082
CMD ${AIRPAL_HOME}/launcher
