pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    } 
    environment {
        AWS_ACCESS_KEY_ID_NEW     = credentials('AWS_ACCESS_KEY_ID_NEW')
        AWS_SECRET_ACCESS_KEY_NEW = credentials('AWS_SECRET_ACCESS_KEY_NEW')
        PATH = "${env.PATH}:/usr/local/bin"  // Add Terraform binary directory to PATH
    }
    agent any
    stages {
        stage('checkout') {
            steps {
                script {
                    dir("terraform") {
                        git "https://github.com/scorcer10/terraform.git"
                    }
                }
            }
        }
        stage('Plan') {
            steps {
                sh 'rm -rf .terraform .terraform.lock.hcl'
                sh 'pwd; cd terraform; terraform init'
                sh 'pwd; cd terraform; terraform plan -out tfplan'
                sh 'pwd; cd terraform; terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }
        stage('Apply') {
            steps {
                sh 'pwd; cd terraform; terraform apply -input=false tfplan'
            }
        }
    }
}
