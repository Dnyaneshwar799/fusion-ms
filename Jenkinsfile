pipeline {

     agent { label 'Jslave-bmw' }

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
    }
}
