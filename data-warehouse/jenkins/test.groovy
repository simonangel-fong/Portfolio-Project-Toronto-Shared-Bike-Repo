pipeline {
    agent {
        docker { image 'node:22.20.0-alpine3.22' }
    }
    stages {
        stage('Test') {
            steps {
                sh 'node --eval "console.log(process.platform,process.env.CI)"'
            }
        }
    }
}