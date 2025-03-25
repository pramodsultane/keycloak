FROM quay.io/keycloak/keycloak:20.0.3 as builder

# Set Keycloak admin credentials
ENV KC_DB=postgres
ENV KC_HTTP_RELATIVE_PATH=/auth
ENV KC_HOSTNAME=localhost
ENV KC_HOSTNAME_PORT=8080
ENV KC_ADMIN_USERNAME=admin
ENV KC_ADMIN_PASSWORD=admin

# Set environment variables for PostgreSQL connection
ENV KC_DB=postgres
ENV KC_DB_HOST=localhost
ENV KC_DB_PORT=5432
ENV KC_DB_URL="jdbc:postgresql://localhost:5432/keycloak"
ENV KC_DB_USERNAME=keycloak
ENV KC_DB_PASSWORD=password

FROM quay.io/keycloak/keycloak:20.0.3

COPY --from=builder /opt/keycloak/ /opt/keycloak/

WORKDIR /opt/keycloak

# Install custom Michelin login theme
COPY themes /opt/keycloak/themes/

USER root
RUN chown -R 100:100 /opt/keycloak
USER 100

# Expose the Keycloak port
EXPOSE 8080

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
