# Login to docker hub: docker login -u hakobhn
FROM maven:3.8.1-jdk-11-openj9 as build-stage

COPY src /usr/src/app/src
COPY pom.xml /usr/src/app

RUN mvn -f /usr/src/app/pom.xml clean package


FROM openjdk:11-jre-slim AS prod-stage
ENV PROFILE=prod
COPY --from=build-stage /usr/src/app/target/reactive-examples-*.jar /usr/local/lib/app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=${PROFILE}", "/usr/local/lib/app.jar"]
