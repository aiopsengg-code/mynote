pipeline {
    agent any

    environment {
        // Replace 'your-dockerhub-username' with your actual DockerHub ID
        IMAGE_NAME = 'devopsengineerr11/mynote'
        DOCKERHUB_CREDENTIALS_ID = 'dockerhubkey' // ID created in Jenkins Credentials store
    }

    stages {
        stage('Code Cloning') {
            steps {
                // Updated to point to the correct repository
                git 'https://github.com/aiopsengg-code/mynote.git'
            }
        }

        stage('Security: SAST Scan') {
            steps {
                // For a static site, Snyk scans the directory for vulnerable dependencies
                sh 'snyk test --all-projects' 
            }
        }

        stage('Building Image') {
            steps {
                // This assumes your Dockerfile is in the root directory
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Security: Container Scan') {
            steps {
                // Scanning the newly built image
                sh 'trivy image --exit-code 1 --severity CRITICAL $IMAGE_NAME:latest'
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Pushing Image to DockerHub') {
            steps {
                sh 'docker push $IMAGE_NAME:latest'
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
        failure {
            echo "Pipeline failed: Security check or build process failed."
        }
    }
}
