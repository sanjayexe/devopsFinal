pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'sanjay188/devopsfinal'
        DOCKER_TAG = "${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        NODE_VERSION = '16.20.2'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Setup Node.js') {
            steps {
                nodejs(nodeJSInstallationName: 'NodeJS') {
                    sh '''
                        echo "Checking Node.js installation..."
                        node --version
                        npm --version
                        echo "Node.js setup completed successfully"
                    '''
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh '''
                    echo "Installing dependencies..."
                    npm install
                    echo "Dependencies installed successfully"
                '''
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
                sh '''
                    echo "Building application..."
                    npm run build
                    echo "Build completed successfully"
                '''
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
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    sh "docker push ${DOCKER_IMAGE}:latest"
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
