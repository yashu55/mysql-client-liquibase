# mysql-client-liquibase-image
FROM openjdk:11

# Check for update
RUN apt-get update

# Install Python 3.7 and PIP 3

RUN apt-get install python3.7 -y
RUN apt install python3-pip -y


# Mysql Release Version
ARG MYSQL_CLIENT_VERSION=8.*

# Mysql install 
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 8C718D3B5072E1F5
RUN echo "deb http://repo.mysql.com/apt/debian/ buster mysql-8.0" > /etc/apt/sources.list.d/mysql.list
RUN apt-get update && apt-get install -y --no-install-recommends mysql-community-client=${MYSQL_CLIENT_VERSION}

# Create liquibase directory
RUN mkdir /liquibase
WORKDIR /liquibase

#Symbolic link will be broken until later
RUN ln -s /liquibase/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh \
  && ln -s /liquibase/docker-entrypoint.sh /docker-entrypoint.sh \
  && ln -s /liquibase/liquibase /usr/local/bin/liquibase

# Liquibase Release Version
ARG LIQUIBASE_VERSION=4.3.5

# Install Liquibase
RUN  wget --no-verbose -O liquibase-${LIQUIBASE_VERSION}.tar.gz https://github.com/liquibase/liquibase/releases/download/v4.3.5/liquibase-${LIQUIBASE_VERSION}.tar.gz \
     && tar -xvf liquibase-${LIQUIBASE_VERSION}.tar.gz \
	 && rm liquibase-${LIQUIBASE_VERSION}.tar.gz \
     && echo "export PATH=/liquibase:$PATH" >> ~/.bashrc \
     && source ~/.bashrc; exit 0

# Download JDBC libraries, verify via GPG and checksum
ARG PG_VERSION=42.2.20
ARG PG_SHA1=36cc2142f46e8f4b77ffc1840ada1ba33d96324f
RUN wget --no-verbose -O /liquibase/lib/postgresql.jar https://repo1.maven.org/maven2/org/postgresql/postgresql/${PG_VERSION}/postgresql-${PG_VERSION}.jar \
	&& wget --no-verbose -O /liquibase/lib/postgresql.jar.asc https://repo1.maven.org/maven2/org/postgresql/postgresql/${PG_VERSION}/postgresql-${PG_VERSION}.jar.asc \
    && gpg --auto-key-locate keyserver --keyserver ha.pool.sks-keyservers.net --keyserver-options auto-key-retrieve --verify /liquibase/lib/postgresql.jar.asc /liquibase/lib/postgresql.jar \
	&& echo "$PG_SHA1  /liquibase/lib/postgresql.jar" | sha1sum -c - 

ARG MSSQL_SHA1=7af72fb8f832634f7717f971a85ba199729b7eaa
RUN wget --no-verbose -O /liquibase/lib/mssql.jar https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/9.2.1.jre11/mssql-jdbc-9.2.1.jre11.jar \
	&& wget --no-verbose -O /liquibase/lib/mssql.jar.asc https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/9.2.1.jre11/mssql-jdbc-9.2.1.jre11.jar.asc \
    && gpg --auto-key-locate keyserver --keyserver ha.pool.sks-keyservers.net --keyserver-options auto-key-retrieve --verify /liquibase/lib/mssql.jar.asc /liquibase/lib/mssql.jar \
	&& echo "$MSSQL_SHA1 /liquibase/lib/mssql.jar" | sha1sum -c - 

ARG MARIADB_SHA1=4a2edc05bd882ad19371d2615c2635dccf8d74f0
RUN wget --no-verbose -O /liquibase/lib/mariadb.jar https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/2.7.3/mariadb-java-client-2.7.3.jar \
	&& wget --no-verbose -O wget -O /liquibase/lib/mariadb.jar.asc https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/2.7.3/mariadb-java-client-2.7.3.jar.asc \
    && gpg --auto-key-locate keyserver --keyserver ha.pool.sks-keyservers.net --keyserver-options auto-key-retrieve --verify /liquibase/lib/mariadb.jar.asc /liquibase/lib/mariadb.jar \
	&& echo "$MARIADB_SHA1 /liquibase/lib/mariadb.jar" | sha1sum -c - 

ARG H2_SHA1=f7533fe7cb8e99c87a43d325a77b4b678ad9031a
RUN wget --no-verbose -O /liquibase/lib/h2.jar https://repo1.maven.org/maven2/com/h2database/h2/1.4.200/h2-1.4.200.jar \
	&& wget --no-verbose -O wget -O /liquibase/lib/h2.jar.asc https://repo1.maven.org/maven2/com/h2database/h2/1.4.200/h2-1.4.200.jar.asc \
    && gpg --auto-key-locate keyserver --keyserver ha.pool.sks-keyservers.net --keyserver-options auto-key-retrieve --verify /liquibase/lib/h2.jar.asc /liquibase/lib/h2.jar \
	&& echo "$H2_SHA1 /liquibase/lib/h2.jar" | sha1sum -c - 

ARG DB2_SHA1=902856c6b9f979facc6f75fad40da6b048df5df8
RUN wget --no-verbose -O /liquibase/lib/db2.jar https://repo1.maven.org/maven2/com/ibm/db2/jcc/11.5.5.0/jcc-11.5.5.0.jar \
	&& wget --no-verbose -O wget -O /liquibase/lib/db2.jar.asc https://repo1.maven.org/maven2/com/ibm/db2/jcc/11.5.5.0/jcc-11.5.5.0.jar.asc \
    && gpg --auto-key-locate keyserver --keyserver keyserver.ubuntu.com --keyserver-options auto-key-retrieve --verify /liquibase/lib/db2.jar.asc /liquibase/lib/db2.jar \
	&& echo "$DB2_SHA1 /liquibase/lib/db2.jar" | sha1sum -c -

ARG SNOWFLAKE_SHA1=bb31bc46f2023910bc71fb12fa0b24ee20ffea25
RUN wget --no-verbose -O /liquibase/lib/snowflake.jar https://repo1.maven.org/maven2/net/snowflake/snowflake-jdbc/3.13.4/snowflake-jdbc-3.13.4.jar \
	&& wget --no-verbose -O wget -O /liquibase/lib/snowflake.jar.asc https://repo1.maven.org/maven2/net/snowflake/snowflake-jdbc/3.13.4/snowflake-jdbc-3.13.4.jar.asc \
    && gpg --auto-key-locate keyserver --keyserver ha.pool.sks-keyservers.net --keyserver-options auto-key-retrieve --verify /liquibase/lib/snowflake.jar.asc /liquibase/lib/snowflake.jar \
	&& echo "$SNOWFLAKE_SHA1 /liquibase/lib/snowflake.jar" | sha1sum -c -

ARG SYBASE_SHA1=4a939221fe3023da2ddfc63ecf902a0f970d4d70
RUN wget --no-verbose -O /liquibase/lib/sybase.jar https://repo1.maven.org/maven2/net/sf/squirrel-sql/plugins/sybase/3.5.0/sybase-3.5.0.jar \
	&& wget --no-verbose -O /liquibase/lib/sybase.jar.asc https://repo1.maven.org/maven2/net/sf/squirrel-sql/plugins/sybase/3.5.0/sybase-3.5.0.jar.asc \
    && gpg --auto-key-locate keyserver --keyserver ha.pool.sks-keyservers.net --keyserver-options auto-key-retrieve --verify /liquibase/lib/sybase.jar.asc /liquibase/lib/sybase.jar \
	&& echo "$SYBASE_SHA1 /liquibase/lib/sybase.jar" | sha1sum -c - 

ARG FIREBIRD_SHA1=40386c1fb29971ab96451a2d0c0d6aafaedea0c0
RUN wget --no-verbose -O /liquibase/lib/firebird.jar https://repo1.maven.org/maven2/net/sf/squirrel-sql/plugins/firebird/3.5.0/firebird-3.5.0.jar \
	&& wget --no-verbose -O wget -O /liquibase/lib/firebird.jar.asc https://repo1.maven.org/maven2/net/sf/squirrel-sql/plugins/firebird/3.5.0/firebird-3.5.0.jar.asc \
    && gpg --auto-key-locate keyserver --keyserver ha.pool.sks-keyservers.net --keyserver-options auto-key-retrieve --verify /liquibase/lib/firebird.jar.asc /liquibase/lib/firebird.jar \
	&& echo "$FIREBIRD_SHA1 /liquibase/lib/firebird.jar" | sha1sum -c - 

ARG SQLITE_SHA1=fd29bb0124e3f79c80b2753162a6a3873c240bcf
RUN wget --no-verbose -O /liquibase/lib/sqlite.jar https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.34.0/sqlite-jdbc-3.34.0.jar \
	&& wget --no-verbose -O /liquibase/lib/sqlite.jar.asc https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.34.0/sqlite-jdbc-3.34.0.jar.asc \
    && gpg --auto-key-locate keyserver --keyserver ha.pool.sks-keyservers.net --keyserver-options auto-key-retrieve --verify /liquibase/lib/sqlite.jar.asc /liquibase/lib/sqlite.jar \
	&& echo "$SQLITE_SHA1 /liquibase/lib/sqlite.jar" | sha1sum -c - 

ARG ORACLE_SHA1=967c0b1a2d5b1435324de34a9b8018d294f8f47b
RUN wget --no-verbose -O /liquibase/lib/ojdbc8.jar https://repo1.maven.org/maven2/com/oracle/ojdbc/ojdbc8/19.3.0.0/ojdbc8-19.3.0.0.jar \
	&& wget --no-verbose -O /liquibase/lib/ojdbc8.jar.asc https://repo1.maven.org/maven2/com/oracle/ojdbc/ojdbc8/19.3.0.0/ojdbc8-19.3.0.0.jar.asc \
    && gpg --auto-key-locate keyserver --keyserver ha.pool.sks-keyservers.net --keyserver-options auto-key-retrieve --verify /liquibase/lib/ojdbc8.jar.asc /liquibase/lib/ojdbc8.jar \
	&& echo "$ORACLE_SHA1 /liquibase/lib/ojdbc8.jar" | sha1sum -c - 

# No key published to Maven Central, using SHA256SUM
ARG MYSQL_SHA256=a0a1be0389e541dad8841b326e79c51d39abbe1ca52267304d76d1cf4801ce96
RUN wget --no-verbose -O /liquibase/lib/mysql.jar https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.25/mysql-connector-java-8.0.25.jar \
	&& echo "$MYSQL_SHA256  /liquibase/lib/mysql.jar" | sha256sum -c - 

COPY docker-entrypoint.sh /liquibase/
COPY liquibase.docker.properties /liquibase/

RUN chmod 777 /liquibase/docker-entrypoint.sh \
    && chmod 777 /liquibase/liquibase.docker.properties

VOLUME /liquibase/classpath
VOLUME /liquibase/changelog

ENTRYPOINT ["/liquibase/docker-entrypoint.sh"]
CMD ["--help"]
