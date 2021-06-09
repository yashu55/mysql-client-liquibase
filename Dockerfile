FROM openjdk:8

RUN apt-get update && apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 8C718D3B5072E1F5

RUN echo "deb http://repo.mysql.com/apt/debian/ buster mysql-8.0" > /etc/apt/sources.list.d/mysql.list

RUN apt-get update && apt-get install -y --no-install-recommends mysql-community-client=8.*

RUN mkdir -p /usr/apps/liquibase; \
        cd /usr/apps/liquibase; \
        wget https://github.com/liquibase/liquibase/releases/download/v4.3.5/liquibase-4.3.5.tar.gz; \
        tar -xvf liquibase-4.3.5.tar.gz; \
        echo "export PATH=/usr/apps/liquibase:$PATH" >> ~/.bashrc; \
        source ~/.bashrc; exit 0

RUN mkdir -p /usr/apps/mysql-connector-java; \
	cd /usr/apps/mysql-connector-java; \
	wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java_8.0.25-1debian10_all.deb; \
	apt -y install ./mysql-connector-java_8.0.25-1debian10_all.deb

CMD ["/bin/bash"]


