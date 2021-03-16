FROM python:3.8-slim-buster
LABEL maintainer="Team QLUSTOR <team@qlustor.com>" \
    description="Original by Aiden Gilmartin. Speedtest to InfluxDB data bridge"

ENV DEBIAN_FRONTEND=noninteractive

RUN true &&\
\
# Install dependencies
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61 && \
echo "deb https://ookla.bintray.com/debian buster main" | tee  /etc/apt/sources.list.d/speedtest.list && \
apt-get update && \
apt-get -q -y install --no-install-recommends apt-utils gnupg1 apt-transport-https dirmngr && \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61 && \
echo "deb https://ookla.bintray.com/debian buster main" | tee  /etc/apt/sources.list.d/speedtest.list && \
apt-get update && \
apt-get -q -y install --no-install-recommends speedtest && \
\
# Install Python packages
pip3 install pythonping influxdb tcp-latency && \
\
# Clean up
apt-get -q -y autoremove && apt-get -q -y clean && \
rm -rf /var/lib/apt/lists/*

# Final setup & execution
ADD . /app
WORKDIR /app
ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]
CMD ["main.py"]
