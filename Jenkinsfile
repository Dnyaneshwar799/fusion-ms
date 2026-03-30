pipeline {

    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '3', artifactNumToKeepStr: '3'))
    }

    tools {
        maven 'maven_3.9.12'
    }

    stages {
        stage('Code Compilation') {
            steps {
                echo 'Starting Code Compilation...'
                sh 'mvn clean compile'
                echo 'Code Compilation Completed Successfully!'
            }
        }
        stage('Code QA Execution') {
            steps {
                echo 'Running JUnit Test Cases...'
                sh 'mvn clean test'
                echo 'JUnit Test Cases Completed Successfully!'
            }
        }
        stage('Code Package') {
            steps {
                echo 'Creating WAR Artifact...'
                sh 'mvn clean package'
                sh '''
                    cp target/*.war target/bookmytrip-1.1.${BUILD_NUMBER}.war
                '''
                echo 'WAR Artifact Created Successfully!'
            }
        }
        stage('Build & Tag Docker Image') {
            steps {
                echo 'Building Docker Image and Tagging...'
                sh "docker build -t satyam88/bookmytrip:latest -t bookmytrip:latest ."
                echo 'Docker Image Build Completed!'
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerhubCred', variable: 'dockerhubCred')]) {
                        sh 'docker login docker.io -u satyam88 -p ${dockerhubCred}'
                        echo 'Pushing Docker Image to Docker Hub...'
                        sh 'docker push satyam88/bookmytrip:latest'
                        echo 'Docker Image Pushed to Docker Hub Successfully!'
                    }
                }
            }
        }
        stage('Push Docker Image to Amazon ECR') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'ecr:ap-south-1:ecr-credentials', url: "https://445842764710.dkr.ecr.ap-south-1.amazonaws.com"]) {
                        echo 'Tagging and Pushing Docker Image to ECR...'
                        sh '''
                            docker images
                            docker tag bookmytrip:latest 445842764710.dkr.ecr.ap-south-1.amazonaws.com/bookmytrip:latest
                            docker push 445842764710.dkr.ecr.ap-south-1.amazonaws.com/bookmytrip:latest
                        '''
                        echo 'Docker Image Pushed to Amazon ECR Successfully!'
                    }
                }
            }
        }
    }
}