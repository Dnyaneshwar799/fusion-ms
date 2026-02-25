
FROM tomcat:10.1-jdk21-openjdk-slim

# Install Java 21
RUN apt-get update && \
    apt-get install -y openjdk-21-jdk && \
    apt-get clean;

# Set Java 21 as the default Java version
RUN update-alternatives --set java /usr/lib/jvm/java-21-openjdk-amd64/bin/java && \
    update-alternatives --set javac /usr/lib/jvm/java-21-openjdk-amd64/bin/javac

# Copy the JAR file into the Tomcat webapps directory
COPY ./target/fusion-ms*.jar /usr/local/tomcat/webapps

# Expose port 8080
EXPOSE 8080

# Set the user
USER fusion

# Set the working directory
WORKDIR /usr/local/tomcat/webapps

# Start Tomcat
CMD ["catalina.sh", "run"]

