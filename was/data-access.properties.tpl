# data-access.properties.tpl
jdbc.driverClassName=com.mysql.cj.jdbc.Driver
jdbc.url=jdbc:mysql://${DB_HOST}/${DB_NAME}?autoReconnect=true&failOverReadOnly=false&connectTimeout=2000&socketTimeout=3000&maxReconnects=3
jdbc.username=${DB_USER}
jdbc.password=${DB_PASSWORD}
jdbc.initLocation=classpath:db/initDB.sql
jdbc.dataLocation=classpath:db/populateDB.sql

