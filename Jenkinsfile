pipeline {
  environment {
		// DockerHub
    // dockerimagename = "cyberslot/react-app"
		dockerimagename = "web-project-init/react-app"
    dockerImage = ""
		// Minikube
		// KUBECONFIG = credentials('test-minikube')
  }
  agent any
  stages {
    stage('Checkout Source') {
      steps {
        // git 'https://github.com/cyberslot/jenkins-kubernetes-deployment.git'
				checkout scmGit(branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-credentials', url: 'https://github.com/cyberslot/jenkins-kubernetes-deployment.git']])
      }
    }
    stage('Build image') {
      steps {
        script {
          dockerImage = docker.build dockerimagename
        }
      }
    }
		// -- Placed in Dockerfile --
		// stage('Run Tests') {
		//   steps {
		//     script {
		//       sh('npm test src/App.test.js') 
		//     }
		//   }
		// }
    stage('Pushing Image') {
      environment {
					// -- Minikube --
          // registryCredential = 'dockerhub-credentials'
					// -- GCP --
					registryCredential = 'gcr-credentials'
          }
      steps {
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
					sh('/var/jenkins_home/bin/kubectl --kubeconfig=$KUBECONFIG apply -f deployment.yaml')
					sh('/var/jenkins_home/bin/kubectl --kubeconfig=$KUBECONFIG apply -f service.yaml')
        }
      }
    }
  }
}
