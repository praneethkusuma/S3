pipeline {
    agent {
        label "master"
    }
    environment {
        S3_BUCKET = 'nayl'
        GIT_REPO_URL = 'https://github.com/praneethkusuma/fundtransfer.git'
        AWS_DEFAULT_REGION = 'ap-south-1'
    }
    parameters {
        string(name: 'main', defaultValue: 'main', description: 'Branch to deploy')
    }
    stages {
        stage('Begin Notifier') {
            steps {  
                wrap([$class: 'BuildUser']) {
                    message: "S3 file deployment is started by ${BUILD_USER} in ${BRANCH_NAME} branch"
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
                        chmod +x ../push_to_s3.sh
                        ../push_to_s3.sh ${S3_BUCKET} ${BRANCH_NAME} ${commitId}
                        '''
                    }
                }
            }
        }
    }
    post {
        failure {
            wrap([$class: 'BuildUser']) {
                message: "S3 file deployment started by ${BUILD_USER} in ${BRANCH_NAME} branch has Failed",
                color: "#FF0000",
                status: "Failure"
            }
        }
        success {
            wrap([$class: 'BuildUser']) {
                message: "S3 file deployment started by ${BUILD_USER} in ${BRANCH_NAME} branch is Successful",
                color: "#00FF00",
                status: "Success"
            }
        }
        unstable {
            wrap([$class: 'BuildUser']) {
                message: "S3 file deployment started by ${BUILD_USER} in ${BRANCH_NAME} branch is Unstable",
                color: "#FFFF00",
                status: "Unstable"
            }
        }
        aborted {
            wrap([$class: 'BuildUser']) {
                message: "S3 file deployment started by ${BUILD_USER} in ${BRANCH_NAME} branch is Aborted",
                color: "#CCEEFF",
                status: "Aborted"
            }
        }
    }
}
