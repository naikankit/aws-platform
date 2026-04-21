pipeline {
    agent {
        node {
            label ''
            customWorkspace "/var/lib/jenkins/workspace/res-terraform-platform/samples"
        }
    }
    parameters {
        choice(
            name: 'ENV',
            choices: ['dev', 'uat', 'prd'],
            description: 'Select environment'
        )
        choice(
            name: 'REG',
            choices: ['us-e2', 'us-w2'],
            description: 'Select region'
        )
    }

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'feature/optimization', url: 'https://github.com/naikankit/aws-platform.git'
            }
        }

        stage('Terraform init') {
   
            steps {
                dir("samples") {
                    sh """
                    terraform init -upgrade
                    """
                }
            }
        }

        stage('Terraform plan') {
            steps {
                dir("samples") {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-creds']
                ]) {
                    sh """
                    pwd && ls -la
                    ls -la ../env/dev/us-e2/
                    terraform plan \
                    -var-file=../env/${params.ENV}/${params.REG}/terraform.tfvars \
                    -out=tfplan
                    """
                    stash name: 'plan', includes: 'tfplan, .terraform.lock.hcl'
                    }
                }
            }
        }


        stage('Terraform Apply') {
            steps {
                dir("samples") {
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

