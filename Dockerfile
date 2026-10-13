FROM node:26-slim AS frontend-build

RUN apt-get update && apt-get install -y make

WORKDIR /frontend

COPY frontend/ ./

# install
RUN make install
# build
RUN make build

FROM eclipse-temurin:21-jdk AS backend-build
RUN apt-get update && apt-get install -y make
WORKDIR /app
COPY Makefile ./
COPY gradlew ./
COPY gradle/ ./gradle
COPY build.gradle.kts ./
COPY settings.gradle.kts ./
COPY src/ ./src
COPY --from=frontend-build /frontend/dist src/main/resources/static

RUN make build

FROM eclipse-temurin:21-jre AS run-app
WORKDIR /app
COPY --from=backend-build /app/build/libs/project-devops-deploy-0.0.1-SNAPSHOT.jar ./build/libs/
RUN mkdir -p /app/logs
RUN mkdir -p /app/tests
CMD ["sh", "-c", "exec java $JAVA_OPTS -jar build/libs/project-devops-deploy-0.0.1-SNAPSHOT.jar >> /app/logs/application.log 2>&1"]

