pipeline {
  environment {
		// DockerHub
    // dockerimagename = "cyberslot/react-app"
		dockerimagename = "europe-docker.pkg.dev/web-project-init/eu.gcr.io/react-app"
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
      // environment {
					// -- DockerHub --
          // registryCredential = 'dockerhub-credentials'
					// -- GCP --
					// registryCredential = 'google-container-registry'
          // }
      steps {
        script {
					// -- DockerHub --
          // docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
					withCredentials([file(credentialsId: 'gcr-id', variable: 'SERVICE_ACCOUNT_KEY')]) {
						sh 'gcloud auth activate-service-account --key-file=$SERVICE_ACCOUNT_KEY'
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
