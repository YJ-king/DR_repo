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

RUN envsubst < /application.properties.tpl > /app/application.properties && \
    envsubst < /data-access.properties.tpl > /app/data-access.properties && \
    envsubst < /datasource-config.xml.tpl > /app/datasource-config.xml && \
    cp /app/application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/application.properties && \
    cp /app/data-access.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/spring/data-access.properties && \
    cp /app/datasource-config.xml /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/spring/datasource-config.xml
