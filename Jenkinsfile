pipeline {
    agent {
        agent { label 'any' } 
    }
    environment {
        S3_BUCKET = 'nayl'
        GIT_REPO_URL = 'https://github.com/praneethkusuma/fundtransfer.git'
        AWS_DEFAULT_REGION = 'ap-south-1'
    }
    parameters {
        string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Branch to deploy')
    }
    stages {
        stage('Begin Notifier') {
            steps {
                script {
                    echo "S3 file deployment started "
                }
            }
        }
        stage('Clone GitLab Repo') {
            steps {
                git branch: "${params.BRANCH_NAME}", url: "${GIT_REPO_URL}"
            }
        }
        stage('Deploy Files to S3') {
            steps {
                script {
                    def commitId = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'your-aws-credentials-id']]) {
                        sh '''#!/bin/bash
                        export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
                        chmod +x ./push_to_s3.sh
                        ./push_to_s3.sh ${S3_BUCKET} ${params.BRANCH_NAME} ${commitId}
                        '''
                    }
                }
            }
        }
    }
    post {
        failure {
            script {
                echo "S3 file deployment started by you in has Failed"
            }
        }
        success {
            script {
                echo "S3 file deployment started by you Successful"
            }
        }
        unstable {
            script {
                echo "S3 file deployment started by you is Unstable"
            }
        }
        aborted {
            script {
                echo "S3 file deployment started by you is Aborted"
            }
        }
    }
}
