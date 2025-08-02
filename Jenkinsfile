pipeline {
    parameters {
        choice(
            name: 'action',
            choices: ['plan', 'apply', 'destroy'],
            description: 'Select the Terraform action to perform'
        )
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply/destroy after generating plan?')
    } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID_NEW')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY_NEW')
        PATH = "${env.PATH}:/opt/homebrew/bin:/usr/local/bin"  // Add Terraform binary directory to PATH
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
                script {
                    sh '''
                        cd terraform
                        echo "Cleaning up previous state..."
                        rm -rf .terraform .terraform.lock.hcl
                        
                        echo "Initializing Terraform..."
                        terraform init
                        
                        echo "Selected action: ${action}"
                        
                        if [ "${action}" = "destroy" ]; then
                            echo "Creating destroy plan..."
                            terraform plan -destroy -out tfplan
                        else
                            echo "Creating ${action} plan..."
                            terraform plan -out tfplan
                        fi
                        
                        echo "Saving plan output..."
                        terraform show -no-color tfplan > tfplan.txt
                    '''
                }
            }
        }
        stage('Approval') {
            when {
                anyOf {
                    equals expected: 'apply', actual: params.action
                    equals expected: 'destroy', actual: params.action
                }
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    def plan = readFile 'terraform/tfplan.txt'
                    def actionText = params.action == 'destroy' ? 'destroy the infrastructure' : 'apply the plan'
                    input message: "Do you want to ${actionText}?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }
        stage('Execute') {
            when {
                anyOf {
                    equals expected: 'apply', actual: params.action
                    equals expected: 'destroy', actual: params.action
                }
            }
            steps {
                script {
                    sh '''
                        cd terraform
                        echo "Executing Terraform ${action}..."
                        terraform apply -input=false tfplan
                        echo "Terraform ${action} completed successfully!"
                    '''
                }
            }
        }
    }
}
