spring.datasource.url=jdbc:mysql://${DB_HOST}/${DB_NAME}?autoReconnect=true&failOverReadOnly=false&connectTimeout=2000&socketTimeout=3000&maxReconnects=3
spring.datasource.username=${DB_USER}
spring.datasource.password=${DB_PASSWORD}
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
server.port=8080
spring.datasource.hikari.connection-init-sql=SET NAMES utf8mb4
spring.datasource.hikari.connection-test-query=SELECT 1

