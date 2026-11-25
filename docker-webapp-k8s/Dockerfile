# syntax=docker/dockerfile:1
# ---------------------------------------------------------------------------
# vprofile web app  ->  multi-stage build (Maven build  ->  Tomcat 9 runtime)
# Build:  docker build -t <dockerhub-user>/vprofile-app:1.0.0 .
# ---------------------------------------------------------------------------

########## Stage 1: build the WAR ##########
FROM maven:3.9-eclipse-temurin-11 AS build
WORKDIR /src

# Copy the POM first so dependency downloads are cached between builds
COPY pom.xml .
RUN --mount=type=cache,target=/root/.m2 mvn -B -q dependency:resolve || true

COPY src ./src
# Tests run in CI; skip them here to keep image builds fast and deterministic
RUN --mount=type=cache,target=/root/.m2 mvn -B package -DskipTests \
 && cp target/*.war /src/app.war

########## Stage 2: runtime ##########
# Tomcat 9 = Servlet 4 / javax.* namespace (Tomcat 10+ would break this app)
FROM tomcat:9.0-jre11-temurin-jammy

# Remove default apps, create an unprivileged user
RUN rm -rf /usr/local/tomcat/webapps/* \
 && groupadd --system --gid 10001 app \
 && useradd  --system --uid 10001 --gid app --home-dir /usr/local/tomcat --shell /usr/sbin/nologin app \
 && mkdir -p /usr/local/tomcat/tmpFiles \
 && chown -R app:app /usr/local/tomcat

COPY --from=build --chown=app:app /src/app.war /usr/local/tomcat/webapps/ROOT.war

# Container-aware JVM sizing (heap = 75% of the pod memory limit)
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0 -XX:+ExitOnOutOfMemoryError -Djava.security.egd=file:/dev/./urandom"

USER 10001
EXPOSE 8080
CMD ["catalina.sh", "run"]
