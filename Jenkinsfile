pipeline {
    agent any
    tools {
        maven 'Maven' // Nom de la configuration Maven dans Global Tool Configuration
        jdk 'JDK'     // Nom de la configuration JDK dans Global Tool Configuration
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Mighritch/DevOps', branch: 'main'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml' // Publie les résultats des tests
                }
            }
        }
        stage('Deploy') {
            steps {
                // Exemple : Déploiement d'un JAR sur un serveur ou conteneur
                sh 'java -jar target/adoptionproject-0.0.1-SNAPSHOT.jar'
                // Ou déploiement vers un serveur distant (AWS, Azure, etc.)
                // Exemple avec AWS : scp target/adoptionproject-0.0.1-SNAPSHOT.jar user@server:/path
            }
        }
    }
    post {
        success {
            echo 'Pipeline terminé avec succès !'
        }
        failure {
            echo 'Échec du pipeline.'
        }
    }
}