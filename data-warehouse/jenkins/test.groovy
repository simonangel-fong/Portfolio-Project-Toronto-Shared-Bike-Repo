pipeline {
    agent any

    stages {
        stage('Clean workspace & Clone repo') {

           
            steps {
                wc("/var/jenkins_home/workspace"){
                    cleanWs()
                    sh """
                    git clone -b feature-dw-dev https://github.com/simonangel-fong/Portfolio-Project-Toronto-Shared-Bike-Repo.git .
                    """
                }

            }
        }
        
        stage('Bring up DB') {
            steps {
                sh '''
                set -e
                
                pwd 
                ls -l
                hostname

                '''
                wc("/var/jenkins_home/workspace"){
                    sh '''
                set -e
                
                pwd 
                ls -l
                hostname

                '''
                }
            }
        }

    }
}