
# -------- Build stage --------
FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml ./
RUN mvn -q -DskipTests dependency:go-offline

COPY src ./src
COPY WebContent ./WebContent

RUN mvn -q -DskipTests package

# -------- Runtime stage --------
# If your code uses javax.* (Servlet 3.x), prefer Tomcat 9:
FROM tomcat:9.0-jdk17-temurin

# Remove default apps for a lighter image
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR into Tomcat webapps; rename to ROOT.war to serve at '/'
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
