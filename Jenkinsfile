pipeline {
  agent {
    label 'X86-64-MULTI'
  }

  environment {
    CONTAINER_NAME = 'docker-base-ubuntu-s6'
    TKF_USER = 'wtfo'
    UBUNTU_VERSION = '18.04'
  }

  stages {
    stage('Setup env') {
      steps {
        script {
          env.EXIT_STATUS = ''
          env.CURR_DATE = sh(
            script: '''date '+%Y-%m-%dT%H:%M:%S%:z' ''',
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
    stage('Docker Hardening') {
      steps {
        sh '''echo "TODO: Determinte how to scan the blasted thing"'''
      }
    }
    stage('Enabling and Building Buildx') {
      steps {
        sh '''
          export DOCKER_CLI_EXPERIMENTAL=enabled
          export DOCKER_BUILDKIT=1
          docker build --platform=local -o . git://github.com/docker/buildx
          mkdir -p ~/.docker/cli-plugins && mv buildx ~/.docker/cli-plugins/docker-buildx
        '''
      }
    }
    stage('Build and Publish') {
      steps {
        sh '''
          export GITHASH_LONG=$(git log -1 --format=%H)
          export GITHASH_SHORT=$(git log -1 --format=%h)
          docker buildx build --build-arg VERSION=${UBUNTU_VERSION} --build-arg BUILD_DATE=${CURR_DATE} -t ${TKF_USER}/${CONTAINER_NAME} -t ${TKF_USER}/${CONTAINER_NAME}:${GITHASH_LONG} -t ${TKF_USER}/${CONTAINER_NAME}:${GITHASH_SHORT} --platform=linux/arm,linux/arm64,linux/amd64 . --push
          docker tag ${TKF_USER}/${CONTAINER_NAME} 
          '''
      }
    }
  }
}
