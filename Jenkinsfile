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
                // Use Node.js installation with error handling
                nodejs(nodeJSInstallationName: 'NodeJS') {
                    try {
                        sh '''
                            echo "Checking Node.js installation..."
                            node --version
                            npm --version
                            echo "Node.js setup completed successfully"
                        '''
                    } catch (Exception e) {
                        echo "Error setting up Node.js: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        error('Node.js setup failed')
                    }
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                try {
                    sh '''
                        echo "Installing dependencies..."
                        npm install
                        echo "Dependencies installed successfully"
                    '''
                } catch (Exception e) {
                    echo "Error installing dependencies: ${e.message}"
                    currentBuild.result = 'FAILURE'
                    error('Dependencies installation failed')
                }
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
                try {
                    sh '''
                        echo "Building application..."
                        npm run build
                        echo "Build completed successfully"
                    '''
                } catch (Exception e) {
                    echo "Error building application: ${e.message}"
                    currentBuild.result = 'FAILURE'
                    error('Build failed')
                }
            }
        }
        
        stage('Build and Push Docker Image') {
            steps {
                script {
                    try {
                        // Build the Docker image
                        docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                        
                        // Login to Docker Hub using your credentials
                        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                        
                        // Push the image to Docker Hub
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                        sh "docker push ${DOCKER_IMAGE}:latest"
                    } catch (Exception e) {
                        echo "Error in Docker operations: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        error('Docker operations failed')
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    try {
                        // Apply Kubernetes deployment
                        sh 'kubectl apply -f deploy.yaml'
                        sh 'kubectl apply -f svc.yaml'
                        
                        // Update deployment with new image
                        sh "kubectl set image deployment/bookstore-app bookstore-app=${DOCKER_IMAGE}:${DOCKER_TAG}"
                    } catch (Exception e) {
                        echo "Error in deployment: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        error('Deployment failed')
                    }
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
