#!/bin/bash

if [ -z "$( egrep "CentOS|Redhat" /etc/issue)" ]; then
	echo 'Only for Redhat or CentOS'
	exit
fi

cd /usr/local/src/
wget http://ftp.cuhk.edu.hk/pub/packages/apache.org/tomcat/tomcat-8/v8.0.12/bin/apache-tomcat-8.0.12.tar.gz
tar zxf apache-tomcat-8.0.12.tar.gz 

mv apache-tomcat-8.0.12 /srv/
ln -s /srv/apache-tomcat-8.0.12 /srv/apache-tomcat
rm -rf /srv/apache-tomcat/webapps/*
cp /srv/apache-tomcat/conf/server.xml{,.original}

cat > /srv/apache-tomcat/bin/setenv.sh <<'EOF'
export JAVA_HOME=/srv/java
export JAVA_OPTS="-server -Xms512m -Xmx8192m  -XX:PermSize=64M -XX:MaxPermSize=512m"
export CATALINA_HOME=/srv/apache-tomcat
export CLASSPATH=$JAVA_HOME/lib:$JAVA_HOME/jre/lib:$CATALINA_HOME/lib:/srv/IngrianJCE/lib/ext/IngrianNAE-5.1.1.jar
export PATH=$PATH:$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$CATALINA_HOME/bin:
EOF

cat >> ~/.bash_profile <<'EOF'
export CATALINA_HOME=/srv/apache-tomcat
export CLASSPATH=/usr/local/java/jdk1.6.0_27/jre/lib/ext/IngrianNAE-5.1.1.jar:/usr/local/apache-tomcat-7.0.21/lib/servlet-api.jar:/usr/local/apache-tomcat-7.0.21/lib/tomcat-api.jar:/usr/local/apache-tomcat-7.0.21/lib/tomcat-coyote.jar:/usr/local/apache-tomcat-7.0.21/lib/tomcat-util.jar:/usr/local/apache-tomcat-7.0.21/bin/tomcat-juli.jar
EOF

groupadd -g 80 www
adduser -o --home /www --uid 80 --gid 80 -c "Web Application" www

chown www:www -R /srv/apache-tomcat-*

su - www -c "/srv/apache-tomcat/bin/startup.sh"