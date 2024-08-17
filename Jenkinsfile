pipeline {
    agent {
        label "master"
    }
    environment {
        S3_BUCKET = 'nayl'
        GIT_REPO_URL = 'https://github.com/praneethkusuma/fundtransfer.git'
        AWS_DEFAULT_REGION = 'ap-south-1'
        targetDirectory = 'QA'
    }
    parameters {
        string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Branch to deploy')
        string(name: 'DIRECTORY', defaultValue: 'QA', description: 'environment')
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
                script {
                    sh "git clone --depth=1 --branch=${params.BRANCH_NAME} ${GIT_REPO_URL} ${params.DIRECTORY}"
                }
            }
        }
        stage('Deploy Files to S3') {
            steps {
                script {
                    //def commitId = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    def commitSHA = sh(returnStdout: true, script: 'git -C ${params.DIRECTORY} rev-parse HEAD').trim()
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'your-aws-credentials-id']]) {
                        sh """
                        #!/bin/bash
                        export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
                        export S3_BUCKET=${S3_BUCKET}
                        export BRANCH_NAME=${params.BRANCH_NAME}
                        export COMMIT_ID=${commitSHA}
                        export TARGETDIR=${params.DIRECTORY}
                        echo "hello"
                        echo "\$COMMIT_ID"
                        chmod +x ./push_to_s3.sh
                        ./push_to_s3.sh \$S3_BUCKET \$BRANCH_NAME \$COMMIT_ID \$TARGETDIR
                        """
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
