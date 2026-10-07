pipeline {
  agent {
    kubernetes {
      yaml '''
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-release
  containers:
    - name: tools
      image: alpine:3.22
      command: ["sleep"]
      args: ["99d"]
'''
    }
  }

  options {
    timestamps()
    disableConcurrentBuilds()
  }

  parameters {
    string(name: 'IMAGE_VERSION', defaultValue: '', description: 'ECR image version, for example 0.0.2')
  }

  stages {
    stage('Prepare tools') {
      steps {
        container('tools') {
          sh 'apk add --no-cache bash curl jq kubectl'
        }
      }
    }

    stage('Deploy and switch') {
      steps {
        lock(resource: 'demo-release') {
          container('tools') {
            sh 'bash jenkins/pipeline/scripts/deploy.sh'
          }
        }
      }
    }
  }
}
