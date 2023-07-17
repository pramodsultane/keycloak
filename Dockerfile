FROM quay.io/keycloak/keycloak:20.0.3 as builder
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_DB=postgres
ENV KC_HTTP_RELATIVE_PATH=/auth
ENV KC_CACHE_CONFIG_FILE=cache-ispn-jdbc-ping.xml

# add custom infinity cache configuration (if clustered)
COPY config/cache-ispn-jdbc-ping.xml /opt/keycloak/conf/cache-ispn-jdbc-ping.xml

# Install custom providers , Add features and build image , Show Keycloak config
RUN <url> --features=impersonation,admin2,account2,admin-fine-grained-authz --cache-config-file=cache-ispn-jdbc-ping.xml &&\
/opt/keycloak/bin/kc.sh show-config

FROM quay.io/keycloak/keycloak:20.0.3

COPY --from=builder /opt/keycloak/ /opt/keycloak/

WORKDIR /opt/keycloak

# Install custom Michelin login theme
COPY themes /opt/keycloak/themes/

USER root
RUN chown -R 100:100 /opt/keycloak
USER 100

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
