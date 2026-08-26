pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        ECR_REPO = "733316173915.dkr.ecr.ap-south-1.amazonaws.com/project2-app"
        IMAGE_TAG = "ci"
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
                    -t ${ECR_REPO}:${IMAGE_TAG} \
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
                    ${ECR_REPO}:${IMAGE_TAG}
                '''
            }
        }

        stage('Test Container') {
            steps {
                sh '''
                    docker run -d \
                    --name ${CONTAINER_NAME} \
                    -p 8081:5000 \
                    ${ECR_REPO}:${IMAGE_TAG}

                    sleep 5

                    curl -f http://localhost:8081/health
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login \
                    --username AWS \
                    --password-stdin ${ECR_REPO}
                '''
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                    docker push ${ECR_REPO}:${IMAGE_TAG}
                '''
            }
        }

        stage('Cleanup') {
            steps {
                sh '''
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    docker rmi ${ECR_REPO}:${IMAGE_TAG} || true
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
            echo 'CI/CD pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check the stage logs.'
        }
    }
}