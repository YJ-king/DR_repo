FROM tomcat:9.0.105-jdk11

RUN apt update && \
    apt install -y bash mysql-client curl gzip unzip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN rm -rf /usr/local/tomcat/webapps/*

COPY ./petclinic_btc/target/petclinic.war /usr/local/tomcat/webapps/ROOT.war

