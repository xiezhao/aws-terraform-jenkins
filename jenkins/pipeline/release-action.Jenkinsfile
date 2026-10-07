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
    choice(name: 'ACTION', choices: ['CONFIRM', 'ROLLBACK'], description: 'Release action')
  }

  stages {
    stage('Prepare tools') {
      steps {
        container('tools') {
          sh 'apk add --no-cache bash kubectl'
        }
      }
    }

    stage('Run action') {
      steps {
        lock(resource: 'demo-release') {
          container('tools') {
            sh 'bash jenkins/pipeline/scripts/release-action.sh'
          }
        }
      }
    }

  }
}
