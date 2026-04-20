pipeline {
    agent any

    environment {
        IMAGE_NAME = 'trivediayush/mydemo-notes'
        DOCKERHUB_CREDENTIALS_ID = 'dockerhub-creds'
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Code Cloning...') {
            steps {
                git 'https://github.com/trivediayush/Notes-Keeping.git'
            }
        }

        stage('Building Image...') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Login to DockerHub...') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Pushing Image to DockerHub...') {
            steps {
                sh 'echo $DOCKER_PASS | sudo -S docker push $IMAGE_NAME:latest'
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}
