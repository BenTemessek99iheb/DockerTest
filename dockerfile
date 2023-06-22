# Use the official maven/Java 17 image to create a build artifact.
FROM maven:3.8.4-openjdk-17 as builder

# Set the working directory in the image
WORKDIR /app

# Copy the pom.xml file
COPY ./pom.xml ./pom.xml

# Build all dependencies for offline use
RUN mvn dependency:go-offline -B

# Copy your source code to the container
COPY ./src ./src

# Package the application
RUN mvn package -DskipTests

# Use openjdk for a runtime environment
FROM openjdk:17-slim

# Set deployment directory
WORKDIR /app

# Copy the jar file built in the first stage
COPY --from=builder /app/target/*.jar /app/app.jar

# Set the startup command to run your binary
CMD ["java","-jar","/app/app.jar"]
