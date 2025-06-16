# Utilise une image de base OpenJDK 17
FROM openjdk:17-jdk-slim

# Définit le répertoire de travail dans le conteneur
WORKDIR /app

# Copie le fichier pom.xml et télécharge les dépendances
COPY pom.xml .
RUN apt-get update && apt-get install -y maven && mvn dependency:go-offline

# Copie le code source
COPY . .

# Compile et emballe l'application
RUN mvn clean package -DskipTests

# Définit le fichier JAR généré comme point d'entrée
ENV JAR_FILE=target/adoptionproject-0.0.1-SNAPSHOT.jar

# Expose le port utilisé par l'application (par défaut 8080 pour Spring Boot)
EXPOSE 8080

# Commande pour exécuter l'application
ENTRYPOINT ["java", "-jar", "/app/target/adoptionproject-0.0.1-SNAPSHOT.jar"]