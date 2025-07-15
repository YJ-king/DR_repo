FROM tomcat:9.0.105-jdk11

RUN apt update && \
    apt install -y bash mysql-client curl && \
    rm -rf /var/lib/apt/lists/*

RUN rm -rf /usr/local/tomcat/webapps/*

COPY ./petclinic_btc/target/petclinic.war /usr/local/tomcat/webapps/ROOT.war

