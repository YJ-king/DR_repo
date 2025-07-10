<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:jee="http://www.springframework.org/schema/jee"
       xsi:schemaLocation="http://www.springframework.org/schema/beans 
           http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="dataSource"
          class="org.apache.tomcat.jdbc.pool.DataSource"
          p:driverClassName="com.mysql.cj.jdbc.Driver"
          p:url="jdbc:mysql://${DB_HOST}/petclinic?useUnicode=true"
          p:username="${DB_USER}"
          p:password="${DB_PASSWORD}" />
</beans>

