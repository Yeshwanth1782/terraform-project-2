pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t project2-app:ci ./app'
            }
        }

        stage('Trivy Image Scan') {
            steps {
                sh '''
                    trivy image \
                    --severity HIGH,CRITICAL \
                    --exit-code 1 \
                    project2-app:ci
                '''
            }
        }

        stage('Test Container') {
            steps {
                sh 'docker run -d --name project2-test -p 8081:5000 project2-app:ci'
                sh 'sleep 5'
                sh 'curl -f http://localhost:8081/health'
            }
        }

        stage('Cleanup') {
            steps {
                sh 'docker stop project2-test || true'
                sh 'docker rm project2-test || true'
            }
        }
    }
}