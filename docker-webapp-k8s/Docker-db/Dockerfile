# ---------------------------------------------------------------------------
# MySQL image with the "accounts" schema + seed data baked in.
# NO passwords in the image: MYSQL_ROOT_PASSWORD / MYSQL_USER / MYSQL_PASSWORD
# are injected at runtime from a Kubernetes Secret.
# Build:  docker build -t <dockerhub-user>/vprofile-db:1.0.0 Docker-db/
#
# Stays on MySQL 5.7 because the app ships mysql-connector-java 5.1.36,
# which cannot talk to MySQL 8.x (see DEPLOYMENT.md -> "Upgrading MySQL").
# ---------------------------------------------------------------------------
FROM mysql:5.7.44

ENV MYSQL_DATABASE=accounts

# Scripts in this folder run once, only when the data directory is empty
COPY db_backup.sql /docker-entrypoint-initdb.d/01-accounts.sql

EXPOSE 3306
