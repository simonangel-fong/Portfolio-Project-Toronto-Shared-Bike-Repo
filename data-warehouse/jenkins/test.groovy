pipeline {
    agent any

    stages {
        stage('Clean workspace & Clone repo') {
            steps {
                cleanWs()
                sh """
                    git clone -b feature-dw-dev https://github.com/simonangel-fong/Portfolio-Project-Toronto-Shared-Bike-Repo.git .
                    git checkout feature-dw-dev
                """
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
            }
        }

    }
}