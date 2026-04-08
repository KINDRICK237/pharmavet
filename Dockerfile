FROM tomcat:10.1-jdk21

# Supprimer les applications par défaut
RUN rm -rf /usr/local/tomcat/webapps/*

# Copier le WAR
COPY target/PharmaVet.war /usr/local/tomcat/webapps/ROOT.war

# Variables d'environnement
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom"

# Port
EXPOSE 8080

# Démarrer Tomcat
CMD ["catalina.sh", "run"]