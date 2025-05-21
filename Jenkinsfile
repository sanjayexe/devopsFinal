pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'sanjay188/devopsfinal'
        DOCKER_TAG = "${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        NODE_VERSION = '18.x'  
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Setup Node.js') {
            steps {
                // Use Node.js installation
                nodejs(nodeJSInstallationName: 'NodeJS') {
                    sh 'node --version'
                    sh 'npm --version'
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        
        stage('Lint') {
            steps {
                sh 'npm run lint'  // If you have linting configured
            }
        }
        
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
        
        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                    
                    // Login to Docker Hub using your credentials
                    sh 'echo virat@18vk | docker login -u sanjay188 --password-stdin'
                    
                    // Push the image to Docker Hub
                    sh "docker push sanjay188/devopsfinal:${DOCKER_TAG}"
                    sh "docker push sanjay188/devopsfinal:latest"
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    // Apply Kubernetes deployment
                    sh 'kubectl apply -f deploy.yaml'
                    sh 'kubectl apply -f svc.yaml'
                    
                    // Update deployment with new image
                    sh "kubectl set image deployment/bookstore-app bookstore-app=${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }
    }
    
    post {
        always {
            // Clean up workspace
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
