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
    timeout(time: 30, unit: 'MINUTES')

    // Prevents Jenkins from automatically checking out the SCM.
    skipDefaultCheckout(true)
  }

  environment {
    POSTGRES_DB = "toronto_shared_bike"
  }

  stages {

    stage('Cleanup Workspace & Checkout') {
      steps {
        echo "#################### Cleans the workspace ####################"
        cleanWs()
        
        echo "#################### Checkout ####################"
        checkout scm
        sh '''
          pwd
          ls -l
        '''
      }
    }

    stage('Start PostgreSQL') {
      steps {
        script{
          withCredentials([
            string(credentialsId: 'postgres_user', variable: 'POSTGRES_USER'),
            string(credentialsId: 'postgres_password', variable: 'POSTGRES_PASSWORD'),
            ]) {
              dir("data-warehouse/postgresql"){
                echo "#################### Spin up PGDB ####################"
                sh '''
                  pwd
                  ls -l
                  docker compose down -v
                  docker compose up -d --build

                  # Wait until Postgres is ready
                  until docker exec -t postgresql bash -lc 'pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"'; do
                    echo "Waiting for PostgreSQL to become ready..."
                    sleep 5
                  done
                '''

                echo "#################### Confirm PGDB ####################"
                sh '''
                  docker ps
                  docker logs --tail=100 postgresql || true
                '''
              }
          }
        }
      }
    }

    stage('Test Database') {
      steps {
        echo "#################### Extract Data ####################"
        sh '''
          echo docker exec -t postgresql bash /scripts/test
        '''
      }
    }
  }

  post {
    always {
      echo "#################### Cleanup PGDB ####################"
      sh '''
      docker compose -f data-warehouse/postgresql/docker-compose.yaml down
      '''

      echo "#################### Cleanup Workspace ####################"
      cleanWs()
    }
    
    failure {
      emailext (
        to: "	tech@arguswatcher.net",
        subject: "FAILURE - ${env.JOB_NAME} (#${env.BUILD_NUMBER})",
        body: "Jenkins pipeline: '${env.JOB_NAME}'\n" +
          "Status: FAILURE \n" +
          "Build URL: ${env.BUILD_URL}"
      )
    }

    success {
      emailext (
        to: "	tech@arguswatcher.net",
        subject: "SUCCESS - ${env.JOB_NAME} (#${env.BUILD_NUMBER})",
        body: "Jenkins pipeline: '${env.JOB_NAME}'\n" +
          "Status: SUCCESS \n" +
          "Build URL: ${env.BUILD_URL}"
      )
    }
  }
}