pipeline {
  agent any

  stages
  {
    stage('Download CSV Files') {
      steps {
        sh '''
        mkdir -pv 
        
        '''
      }s
    }
    // stage('Start PostgreSQL') {
    //   steps {
    //     sh '''
    //     docker --version
    //     docker compose -f data-warehouse/postgresql/docker-compose.yaml up -d --build
    //     docker logs postgresql
    //     '''
    //   }
    // }

    // stage('Extract Data') {
    //   steps {
    //     sh '''
    //     docker exec -t postgresql bash /scripts/etl/extract.sh
    //     '''
    //   }
    // }
    // stage('Transform Data') {
    //   steps {
    //     sh '''
    //     echo Transform
    //     '''
    //   }
    // }
    // stage('Load Data') {
    //   steps {
    //     sh 'echo Load'
    //   }
    // }
    // stage('Refresh MV') {
    //   steps {
    //     sh 'echo Refresh'
    //   }
    // }
    // stage('Export Data') {
    //   steps {
    //     sh 'echo Export'
    //   }
    // }
    // stage('Upload Data') {
    //   steps {
    //     sh 'echo Upload'
    //   }
    // }
  }

  // post {
  //   always {
  //     sh '''
  //     docker --version
  //     docker compose -f data-warehouse/postgresql/docker-compose.yaml down -v
  //     '''
  //   }
  //   success {
  //     echo 'Pipeline succeeded! Sending success notification.'
  //   // mail to: 'devs@example.com', subject: 'Pipeline Success'
  //   }
  //   failure {
  //     echo 'Pipeline failed! Sending failure notification.'
  //   // mail to: 'devs@example.com', subject: 'Pipeline Failure'
  //   }
  // }
}
