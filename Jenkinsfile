pipeline {
    agent {
        label "master"
    }
    environment {
        S3_BUCKET = 'nayl'
        GIT_REPO_URL = 'https://github.com/praneethkusuma/fundtransfer.git'
        TARGET_DIRECTORY = 'QA'
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
                    sh "git clone --depth=1 --branch=${params.BRANCH_NAME} ${GIT_REPO_URL} ${TARGET_DIRECTORY}/code"
                }
            }
        }
        stage('Deploy Files to S3') {
            steps {
                script {
                    //def commitId = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    def commitSHA = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                     echo "Commit SHA: ${commitSHA}"
                    def BRANCHNAME = BRANCH_NAME.replaceAll('/', '')
                    def SOURCE_DIRECTORY = "${TARGET_DIRECTORY}/code"
                    // withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'your-aws-credentials-id']]) {
                        sh """
                        #!/bin/bash
                        echo "hello"
                        echo "\$commitSHA"
                        aws s3 cp $SOURCE_DIRECTORY/ s3://$S3_BUCKET/$BRANCHNAME-$commitSHA/ --acl bucket-owner-full-control --recursive
                        echo $? > output.status
                        def ExitCode = readFile("${TARGET_DIRECTORY}/code/output.status").trim()
                        echo "Exit Code: ${ExitCode}"
                        if (ExitCode = "0")
                             echo "All files have been uploaded to S3 under $BRANCH_NAME-$commitSHA "
                        else
                             echo "Failed to upload the files."
                             exit 1
                        fi
                        """
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
