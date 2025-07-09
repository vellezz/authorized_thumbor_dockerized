FROM envoyproxy/envoy:v1.30-latest

RUN apt-get update && apt-get install -y gettext-base
COPY envoy.yaml.template /etc/envoy/envoy.yaml.template
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
