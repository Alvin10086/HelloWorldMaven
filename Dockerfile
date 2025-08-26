# Stage 1: Build stage
FROM maven:3-openjdk-21 AS builder

# Set the working directory
WORKDIR /app

# Copy pom.xml and download dependencies first (better caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the rest of the source code
COPY src ./src

# Package the application (including dependencies)
RUN mvn clean package -DskipTests

# Stage 2: Runtime stage
FROM openjdk:21-slim

WORKDIR /app

# Copy the JAR file from builder stage
COPY --from=builder /app/target/HelloWorldMaven-*-jar-with-dependencies.jar app.jar

# Run the application
CMD ["java", "-jar", "app.jar"]