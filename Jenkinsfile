pipeline {
    agent any

    parameters {
        choice(
            name: 'ENV',
            choices: ['dev', 'uat', 'prd'],
            description: 'Select environment'
        )
    }

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/naikankit/aws-platform.git'
            }
        }

        stage('Terraform Init') {
            dir('/samples/')
            steps {
                sh 'terraform init'
                sh 'ls -la && pwd'
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-creds']
                ]) {
                    sh """
                    terraform plan \
                    -var-file=env/${params.ENV}/us-e2/terraform.tfvars \
                    -out=tfplan
                    """
                }
            }
        }


        stage('Terraform Apply') {
            steps {
                input message: "Approve apply for ${params.ENV}?"

                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-creds']
                ]) {
                    sh """
                    terraform apply -auto-approve tfplan
                    """
                }
            }
        }
    }
}

