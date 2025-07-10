FROM maven:3.9-eclipse-temurin-17 AS yjmulti
WORKDIR /app

COPY ./petclinic_btc/ .

RUN mvn clean package -DskipTests -PMySQL

FROM tomcat:9.0.105-jdk11

RUN apt update && \
    apt install -y bash mysql-client && \
    rm -rf /var/lib/apt/lists/*

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=yjmulti /app/target/petclinic.war /usr/local/tomcat/webapps/ROOT.war
