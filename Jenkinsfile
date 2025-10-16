pipeline {
    agent any

    parameters {
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Tag for the Docker image')
        string(name: 'CONTAINER_NAME', defaultValue: 'ever-cart-container', description: 'Name of the Docker container')
        string(name: 'HOST_PORT', defaultValue: '8080', description: 'Host port to map to container port 3000')
    }

    environment {
        DOCKER_IMAGE = "cap-ever-cart-app:${params.IMAGE_TAG}"
        DOCKER_HUB_REPO = "harshii0520/cap-ever-cart-app"
        ECR_REPO = "636768524979.dkr.ecr.eu-north-1.amazonaws.com/harshi-repo"
        CONTAINER_PORT = "3000"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/Harshithanarukulla/Ever-Cart-App-Project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Docker_credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    sh "docker tag ${DOCKER_IMAGE} ${DOCKER_HUB_REPO}:${params.IMAGE_TAG}"
                    sh "docker push ${DOCKER_HUB_REPO}:${params.IMAGE_TAG}"
                }
            }
        }

        stage('Login to AWS ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Credentials']]) {
                    sh '''
                        aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 636768524979.dkr.ecr.eu-north-1.amazonaws.com
                    '''
                }
            }
        }

        stage('Push to AWS ECR') {
            steps {
                script {
                    sh "docker tag ${DOCKER_IMAGE} ${ECR_REPO}:${params.IMAGE_TAG}"
                    sh "docker push ${ECR_REPO}:${params.IMAGE_TAG}"
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    sh '''
                        docker rm -f ${CONTAINER_NAME} || true
                        docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:${CONTAINER_PORT} ${DOCKER_IMAGE}
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Deployment successful!"
        }
        failure {
            echo "Deployment failed!"
        }
    }
}
