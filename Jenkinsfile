pipeline {
  environment {
    dockerimagename = "cyberslot/react-app"
    dockerImage = ""
		KUBECONFIG = credentials('test-minikube')
  }
  agent any
  stages {
    // stage('Checkout Source') {
    //   steps {
    //     git 'https://github.com/cyberslot/jenkins-kubernetes-deployment.git'
    //   }
    // }
    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build dockerimagename
        }
      }
    }
    stage('Pushing Image') {
      environment {
          registryCredential = 'dockerhub-credentials'
           }
      steps{
        script {
          docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
            dockerImage.push("latest")
          }
        }
      }
    }
    stage('Deploying React.js container to Kubernetes') {
      steps {
        script {
          // kubernetesDeploy(configs: "deployment.yaml", "service.yaml")
					sh "/var/jenkins_home/bin/kubectl --kubeconfig=$KUBECONFIG apply -f deployment.yaml"
					sh "/var/jenkins_home/bin/kubectl --kubeconfig=$KUBECONFIG apply -f service.yaml"
        }
      }
    }
  }
}
