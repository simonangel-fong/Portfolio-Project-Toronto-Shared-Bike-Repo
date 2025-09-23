pipeline {
  agent any

  options {
    // limit only one instance
    disableConcurrentBuilds()
    // show timestamp for event
    timestamps()
    // discard old builds
    buildDiscarder(
      logRotator(
        // maximum number of the last build logs
        numToKeepStr: '10',   
        // maximum number of the last sets of build artifacts
        artifactNumToKeepStr: '5'   
      )
    )
    // set a timeout for the entire pipeline run
    timeout(time: 60, unit: 'MINUTES')

    //Prevents Jenkins from automatically checking out the SCM.
    skipDefaultCheckout(true)
  }

  triggers {
    cron 'H H/4 * * *'    // run every four hours
  }

  environment {
    POSTGRES_USER = 'postgres'
    POSTGRES_PASSWORD = 'SecurePassword123'
    POSTGRES_DB = 'toronto_shared_bike'
    PGDATA = '/var/lib/postgresql/data/pgdata'
    // S3_PROFILE = 'toronto_shared_bike'
    // S3_BUCKET  = 'toronto-shared-bike-data-warehouse-data-bucket'
    // RAW_URL = 'https://toronto-shared-bike-data-warehouse-data-bucket.s3.ca-central-1.amazonaws.com/raw/data.zip'
    // S3_PREFIX  = "mv" 
    // EXPORT_DIR = '/export'
    
    // COMPOSE_PROJECT_NAME = "${env.JOB_NAME}-${env.BUILD_NUMBER}"
    // PRJECT_NAME = 'toronto_shared_bike'
    // POSTGRES_DOCKE_FILE = 'data-warehouse/postgresql/docker-compose.yaml'
    // EXPORT_DIR = '/export'
    
    PROJECT_NAME = 'toronto_shared_bike'
    AWS_REGION = 'ca-central-1'
    S3_CREDENTIAL = 'toronto_shared_bike'
    S3_BUCKET = "toronto-shared-bike-data-warehouse-data-bucket"
    S3_PREFIX = "test"
    CSV_DIR = "/export"
    CSV_PATTERN = "**/*.csv"
  }

  stages {

    stage('Upload to S3') {
      steps {
        script{
          withAWS(credentials: env.S3_CREDENTIAL, region: env.AWS_REGION) {
            s3Upload(
              bucket: env.S3_BUCKET, 
              path: env.S3_PREFIX, 
              workingDir: env.CSV_DIR,
              includePathPattern: env.CSV_PATTERN,
            )
          }
        }
      }
    }
  }

  post {
    always {
      echo "#################### Cleanup Workspace ####################"
      cleanWs()
    }
    
    failure {
      emailext (
        to: "tech.arguswatcher@gmail.com",
        subject: "${env.PROJECT_NAME} JENKINS FAILURE: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
        body: "${env.PROJECT_NAME} Jenkins pipeline '${env.JOB_NAME}' failed.\n" +
          "Build URL: ${env.BUILD_URL}",
      )
    }

    success {
      emailext (
        to: "tech.arguswatcher@gmail.com",
        subject: "${env.PROJECT_NAME} JENKINS SUCCESS: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
        body: "${env.PROJECT_NAME} Jenkins pipeline '${env.JOB_NAME}' completed successfully.\n" +
          "Build URL: ${env.BUILD_URL}",
      )
    }
  }
}
