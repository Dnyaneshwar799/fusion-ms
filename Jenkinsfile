pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    }

    tools {
        maven 'maven_3.9.12'
    }


    stages {
        stage('Code Compilation') {
            steps {
                echo 'Code Compilation is In Progress!'
                sh 'mvn clean compile'
                        echo 'Code Compilation is Completed Successfully!'
                    }
                }

                stage('Code QA Execution') {
                    steps {
                        echo 'JUnit Test Case Check in Progress!'
                        sh 'mvn clean test'
                        echo 'JUnit Test Case Check Completed!'
                    }
                }

                stage('Code Package') {
                    steps {
                        echo 'Creating WAR Artifact'
                        sh 'mvn clean package'
                        echo 'Artifact Creation Completed'
                    }
                }

                stage('Building & Tag Docker Image') {
                    steps {
                        echo "Starting Building Docker Image"
                        sh "docker build -t fusion-ms ."
                        echo 'Docker Image Build Completed'
                    }
                }
                 stage ('Docker Image Scanning') {
                    steps {
                        echo 'Docker Image Scanning Started'
                        sh 'docker --version'
                        echo 'Docker Image Scanning Started'
                    }
                }
                stage('Docker Push to Docker Hub') {
                    steps {
                        script {
                        withCredentials([usernamePassword(credentialsId: 'DOCKER_HUB_CRED', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                            echo "Pushing Docker Image to DockerHub: ${env.IMAGE_NAME}"
                            sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                            sh "docker push ${env.IMAGE_NAME}"
                            echo "Docker Image Push to DockerHub Completed"
                        }
                    }
                }

                stage('Docker Image Push to Amazon ECR') {
                    steps {
                        script {
                        echo "Tagging Docker Image for ECR"
                        sh "docker tag ${env.IMAGE_NAME} ${env.ECR_IMAGE_NAME}"
                        echo "Docker Image Tagging Completed"

                        withDockerRegistry([credentialsId: 'ecr:ap-south-2:ecr-credentials', url: "https://${ECR_URL}"]) {
                            echo "Pushing Docker Image to ECR: ${env.ECR_IMAGE_NAME}"
                            sh "docker push ${env.ECR_IMAGE_NAME}"
                            echo "Docker Image Push to ECR Completed"
                        }
                    }
                }
            }
        }
}
