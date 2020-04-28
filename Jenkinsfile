pipeline {
  agent {
    label 'X86-64-MULTI'
  }

  environment {
    CONTAINER_NAME = 'docker-base-ubuntu-s6'
    TKF_USER = 'wtfo'
    UBUNTU_VERSION = '18.04'

    LOCAL_DOCKER_PROXY="docker.copperdale.teknofile.net/"
    SCAN_SCRIPT="https://nexus.copperdale.teknofile.net/repository/teknofile-utils/teknofile/ci/utils/tkf-inline-scan-v0.6.0-1.sh"
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
          '''
      }
    }
    stage('Image Scan') {
      steps {
        sh 'curl -s ${SCAN_SCRIPT} | bash -s -- -t 1800 -r -p ${LOCAL_DOCKER_PROXY}${TKF_USER}/${CONTAINER_NAME}'
      }
    }
  }
}
