pipeline {
    agent any

    environment {
        IMAGE_NAME = 'devopsengineerr11/mynote'
        DOCKERHUB_CREDENTIALS_ID = 'dockerhubkey'
        BRANCH_NAME = 'main'
    }

    options {
        skipDefaultCheckout(true)
    }

    stages {

        stage('Code Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "*/${BRANCH_NAME}"]],
                    userRemoteConfigs: [[
                        url: 'https://github.com/aiopsengg-code/mynote.git'
                    ]]
                ])
            }
        }

        stage('Security: SAST Scan (Snyk)') {
            steps {
                script {
                    sh '''
                        if command -v snyk >/dev/null 2>&1; then
                          snyk test --all-projects || true
                        else
                          echo "Snyk not installed, skipping SAST scan"
                        fi
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Security: Container Scan (Trivy)') {
            steps {
                script {
                    sh '''
                        if command -v trivy >/dev/null 2>&1; then
                          trivy image $IMAGE_NAME:latest || true
                        else
                          echo "Trivy not installed, skipping container scan"
                        fi
                    '''
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: DOCKERHUB_CREDENTIALS_ID,
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE_NAME:latest'
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
        }
        success {
            echo "✅ Pipeline completed successfully"
        }
        failure {
            echo "❌ Pipeline failed — check logs above"
        }
    }
}
