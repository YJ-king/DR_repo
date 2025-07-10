# === 1단계: 빌드 스테이지 ===
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app

COPY ./petclinic_btc/ .
RUN mvn clean package -DskipTests -PMySQL

# === 2단계: 런타임 스테이지 ===
FROM tomcat:9.0.105-jdk11

# 필수 패키지 설치
RUN apt-get update && \
    apt-get install -y gettext-base && \
    rm -rf /var/lib/apt/lists/*

# WAR 복사
COPY --from=builder /app/target/petclinic.war /usr/local/tomcat/webapps/ROOT.war

# 템플릿 복사
COPY application.properties.tpl /config/application.properties.tpl
COPY data-access.properties.tpl /config/data-access.properties.tpl
COPY datasource-config.xml.tpl /config/datasource-config.xml.tpl

# CMD: envsubst로 치환 후 시작
CMD ["/bin/bash", "-c", "\
  mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/spring && \
  envsubst < /config/application.properties.tpl > /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/application.properties && \
  envsubst < /config/data-access.properties.tpl > /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/spring/data-access.properties && \
  envsubst < /config/datasource-config.xml.tpl > /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/spring/datasource-config.xml && \
  catalina.sh run"]

