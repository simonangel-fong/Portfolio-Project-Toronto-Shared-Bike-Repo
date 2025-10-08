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
                # find the jenkins_home path on the host
                HOST_JENKINS_HOME=$(docker inspect jenkins --format '{{range .Mounts}}{{if eq .Destination "/var/jenkins_home"}}{{.Source}}{{end}}{{end}}')

                # get the ws path on the host
                HOST_WORKSPACE="$HOST_JENKINS_HOME/workspace/$JOB_NAME"

                echo "HOST_JENKINS_HOME=$HOST_JENKINS_HOME"
                echo "HOST_WORKSPACE=$HOST_WORKSPACE"

                # check the script
                ls -la "$HOST_WORKSPACE/data-warehouse/postgresql/scripts"
                
                DIR_PG="$HOST_WORKSPACE/data-warehouse/postgresql"
                # set env var 
                export DIR_PG

                # bring up container
                cd $DIR_PG
                docker compose up -d

                # Verify
                docker exec -it postgresql ls -la /scripts
                '''
            }
        }

    }
}