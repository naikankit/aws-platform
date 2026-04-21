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

        stage('Terraform init') {
   
            steps {
                dir('/var/lib/jenkins/workspace/res-terraform-platform/samples') {
                    sh """
                    terraform init -upgrade
                    """
                }
            }
        }

        stage('Terraform plan') {
            steps {
                dir('/var/lib/jenkins/workspace/res-terraform-platform/samples') {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-creds']
                ]) {
                    sh """
                    terraform plan \
                    -var-file=env/${params.ENV}/us-e2/terraform.tfvars \
                    -out=tfplan
                    """
                    stash name: 'plan', includes: 'tfplan, .terraform.lock.hcl'
                    }
                }
            }
        }


        stage('Terraform Apply') {
            steps {
                dir('/var/lib/jenkins/workspace/res-terraform-platform/samples') {                
                unstash 'plan' // Bring the file back
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
}

