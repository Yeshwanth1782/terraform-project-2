pipeline {
    agent any

    environment {
        IMAGE_NAME = "project2-app"
        IMAGE_TAG  = "ci"
        CONTAINER_NAME = "project2-test"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                    -t ${IMAGE_NAME}:${IMAGE_TAG} \
                    ./app
                '''
            }
        }

        stage('Trivy Image Scan') {
            steps {
                sh '''
                    trivy image \
                    --scanners vuln \
                    --severity HIGH,CRITICAL \
                    --exit-code 1 \
                    ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Test Container') {
            steps {
                sh '''
                    docker run -d \
                    --name ${CONTAINER_NAME} \
                    -p 8081:5000 \
                    ${IMAGE_NAME}:${IMAGE_TAG}

                    sleep 5

                    curl -f http://localhost:8081/health
                '''
            }
        }

        stage('Cleanup') {
            steps {
                sh '''
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true
                '''
            }
        }
    }

    post {
        always {
            sh '''
                docker stop ${CONTAINER_NAME} 2>/dev/null || true
                docker rm ${CONTAINER_NAME} 2>/dev/null || true
            '''
        }

        success {
            echo 'CI Pipeline completed successfully!'
        }

        failure {
            echo 'CI Pipeline failed. Check the stage logs.'
        }
    }
}