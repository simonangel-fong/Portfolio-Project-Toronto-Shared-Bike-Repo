pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['qa', 'prod'], description: 'Deployment environment')
    }

    environment {
        // REMOTE_DATA="https://toronto-shared-bike-data-warehouse-data-bucket.s3.ca-central-1.amazonaws.com/raw/data.zip"
        REMOTE_DATA="https://toronto-shared-bike-data-warehouse-data-bucket.s3.ca-central-1.amazonaws.com/raw/test_data.zip"
        POSTGRES_DB = "toronto_shared_bike"
    }

    stages {
        stage('Clean workspace & Clone repo') {
            steps {
                cleanWs()
                checkout scmGit(
                    branches: [[name: 'feature-dw-dev']], 
                    userRemoteConfigs: [[url: 'https://github.com/simonangel-fong/Portfolio-Project-Toronto-Shared-Bike-Repo.git']]
                )
            }
        }

        stage('parameter') {
            steps {
                echo "Deploying to ${params.ENVIRONMENT}" 
            }
        }
    }
}
 