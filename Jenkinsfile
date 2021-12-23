pipeline {
  agent {
    label 'X86-64-MULTI'
  }

  environment {
    CONTAINER_NAME = 'docker-base-ubuntu-s6'
    TKF_USER = 'teknofile'
    UBUNTU_VERSION = '20.04'
  }

  stages {
    stage('Setup enviornment and Start ') {
      steps {
        // slackSend (color: '#ffff00', message: "STARTED: Job '${env.JOB_NAME}' [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")

        script {
          env.EXIT_STATUS = ''

          env.CURR_DATE = sh(
            script: '''date '+%Y-%m-%dT%H:%M:%S%:z' ''',
            returnStdout: true).trim()

          env.GITHASH_LONG = sh(
            script: '''git log -1 --format=%H''',
            returnStdout: true).trim()

          env.GITHASH_SHORT = sh(
            script: '''git log -1 --format=%h''',
            returnStdout: true).trim()

        }
      }
    }
    stage('Docker Linting') {
      steps {
        sh '''
          docker run --rm -i hadolint/hadolint < Dockerfile || true
        '''
      }
    }
    stage('Build and Publish') {
      steps {
        script {
          withDockerRegistry(credentialsId: 'teknofile-dockerhub') {
            sh '''
              docker buildx create --use --name tkf-builder-${CONTAINER_NAME}-${GITHASH_SHORT}

              docker buildx build \
                --build-arg VERSION=${UBUNTU_VERSION} \
                --build-arg BUILD_DATE=${CURR_DATE} \
                -t ${TKF_USER}/${CONTAINER_NAME} \
                -t ${TKF_USER}/${CONTAINER_NAME}:latest \
                -t ${TKF_USER}/${CONTAINER_NAME}:${GITHASH_LONG} \
                -t ${TKF_USER}/${CONTAINER_NAME}:${GITHASH_SHORT} \
                -t ${TKF_USER}/${CONTAINER_NAME}:${UBUNTU_VERSION} \
                -t ${TKF_USER}/${CONTAINER_NAME}:focal
                --platform=linux/arm,linux/arm64,linux/amd64 \
                . \
                --push

              docker buildx stop tkf-builder-${CONTAINER_NAME}-${GITHASH_SHORT}
              docker buildx rm tkf-builder-${CONTAINER_NAME}-${GITHASH_SHORT}
            '''
          }
        }
      }
    }
  }
  post {
    success {
      slackSend(color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    }

    failure {
      slackSend(color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    }
  }
}
