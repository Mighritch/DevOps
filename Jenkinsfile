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
                // Construire l'image Docker
                sh 'docker build -t adoptionproject .'
                // Taguer l'image
                sh 'docker tag adoptionproject <votre-utilisateur>/adoptionproject:latest'
                // Connecter à Docker Hub (utilise credentials si possible)
                sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                // Pousser l'image
                sh 'docker push <votre-utilisateur>/adoptionproject:latest'
                // Lancer le conteneur (optionnel)
                sh 'docker run -d -p 8080:8080 <votre-utilisateur>/adoptionproject:latest'
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