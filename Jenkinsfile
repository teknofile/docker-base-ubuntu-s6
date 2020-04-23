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
    // Run SHellCheck
    stage('ShellCheck') {
      steps {
        sh '''echo "TODO: Determine a good strategy for finding and scanning shell code"'''
      }
    }
    stage('Docker Linting') {
      steps {
        sh '''echo "TODO: Determine a good strategy for linting a Dockerfile"'''
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
      }
    }
    stage('Build and Publish') {
      steps {
        sh '''
          docker buildx build --build-arg VERSION=${UBUNTU_VERSION} --build-arg BUILD_DATE=${CURR_DATE} -t ${TKF_USER}/${CONTAINER_NAME} --platform=linux/arm,linux/arm65,linux/amd64 . --push

          //docker stop buildx_buildkit_mybuilder0
          //docker rm buildx_buildkit_mybuilder0
          '''
      }
    }
  }
}
