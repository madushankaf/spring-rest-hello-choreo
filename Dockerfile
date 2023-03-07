FROM maven:3.8.3-openjdk-11-slim AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -B -f pom.xml -s /usr/share/maven/ref/settings-docker.xml dependency:resolve
COPY src/ /app/src/
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package -DskipTests

# Use an OpenJDK 11 runtime as the base image
FROM openjdk:11-jre-slim

RUN apk add --upgrade libtasn1-progs

# https://security.alpinelinux.org/vuln/CVE-2022-37434
RUN apk update && apk upgrade zlib

# Set the working directory in the container
WORKDIR /app

USER 10001

RUN ls -la /app
# Copy the compiled JAR file to the container
COPY --from=0 "/app/target/spring-rest-hello-world-1.0.jar" spring-rest-hello-world.jar

# Expose the port that the API will listen on
EXPOSE 9091

# Start the Spring Boot application when the container starts
CMD ["java", "-jar", "-Dserver.address=0.0.0.0", "-Dserver.port=9091",  "spring-rest-hello-world.jar"]

