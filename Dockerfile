# Use an OpenJDK 11 runtime as the base image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

USER 10001
# Copy the compiled JAR file to the container
COPY target/spring-rest-hello-world-1.0.jar spring-rest-hello-world.jar

# Expose the port that the API will listen on
EXPOSE 9091

# Start the Spring Boot application when the container starts
CMD ["java", "-jar", "-Dserver.address=0.0.0.0", "-Dserver.port=9091",  "spring-rest-hello-world.jar"]