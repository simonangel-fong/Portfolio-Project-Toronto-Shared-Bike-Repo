pipeline {
    agent any

    environment {
        // REMOTE_DATA="https://toronto-shared-bike-data-warehouse-data-bucket.s3.ca-central-1.amazonaws.com/raw/data.zip"
        REMOTE_DATA="https://toronto-shared-bike-data-warehouse-data-bucket.s3.ca-central-1.amazonaws.com/raw/test_data.zip"
        POSTGRES_DB = "toronto_shared_bike"
        GMAIL = credentials('gmail_cred')
    }

    stages {
        stage('Clean workspace & Clone repo') {
            steps {
                echo "#################### Email ####################"
                echo "Username: ${GMAIL_USR}"
                emailext (
                    to: "${GMAIL_USR}",
                    subject: "Jekins Pipeline FAILURE - ${env.JOB_NAME} (#${env.BUILD_NUMBER})",
                    body: "Jenkins pipeline: '${env.JOB_NAME}'\n" +
                        "Status: FAILURE \n" +
                        "Build URL: ${env.BUILD_URL}"
                )
            }
        }
    }
}