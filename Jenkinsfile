pipeline {
    agent any
    tools {
        maven 'Maven' // Maven configuration in Jenkins Global Tool Configuration
        jdk 'JDK17'   // JDK 17 configuration in Jenkins Global Tool Configuration
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials') // Docker Hub credentials ID in Jenkins
        NEXUS_CREDENTIALS = credentials('nexus-credentials') // Nexus credentials ID in Jenkins
        NEXUS_URL = 'http://nexus:8081/repository/maven-releases/' // Nexus repository URL
        SONARQUBE_SCANNER = 'SonarQubeScanner' // SonarQube Scanner tool name in Jenkins
        DOCKER_IMAGE = '<your-dockerhub-username>/adoptionproject'
        VERSION = "${env.BUILD_NUMBER}" // Use Jenkins build number as version
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Mighritch/DevOps', branch: 'main'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') { // SonarQube server name in Jenkins configuration
                    sh "mvn sonar:sonar -Dsonar.projectKey=adoptionproject -Dsonar.host.url=http://sonarqube:9000 -Dsonar.login=${SONARQUBE_TOKEN}"
                }
            }
        }
        stage('Prepare Release') {
            steps {
                sh "mvn versions:set -DnewVersion=1.0.${VERSION}"
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Deploy to Nexus') {
            steps {
                sh """
                    mvn deploy -DskipTests \
                    -DaltDeploymentRepository=nexus::default::${NEXUS_URL} \
                    -Dusername=${NEXUS_CREDENTIALS_USR} \
                    -Dpassword=${NEXUS_CREDENTIALS_PSW}
                """
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${VERSION} ."
                sh "docker tag ${DOCKER_IMAGE}:${VERSION} ${DOCKER_IMAGE}:latest"
            }
        }
        stage('Push to DockerHub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh "docker push ${DOCKER_IMAGE}:${VERSION}"
                sh "docker push ${DOCKER_IMAGE}:latest"
            }
        }
        stage('Deploy with Docker Compose') {
            steps {
                sh 'docker-compose -f docker-compose.yml up -d'
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
        always {
            sh 'docker logout' // Ensure Docker logout
        }
    }
}