# Base image:
FROM eclipse-temurin:17-jdk-alpine

# Set goodies:
MAINTAINER Krasimir Vasilev
LABEL maintainer="darkmill@gmail.com"

# Copy the compiled jar file to the docker image:
COPY ./build/libs/spring-boot-0.0.1-SNAPSHOT.jar app.jar

# Start the app after container has been initialized:
ENTRYPOINT [ "java", "-jar", "/app.jar" ]
