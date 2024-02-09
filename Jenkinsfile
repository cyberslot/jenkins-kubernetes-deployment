pipeline {
  environment {
		// -- DockerHub --
    // dockerimagename = "cyberslot/react-app"
		dockerimagename = "europe-docker.pkg.dev/web-project-init/eu.gcr.io/react-app"
    dockerImage = ""
		// -- Minikube --
		// KUBECONFIG = credentials('test-minikube')
		KUBECONFIG = credentials('gke')
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
          // }
      steps {
        script {
					// -- DockerHub --
          // docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
					withCredentials([file(credentialsId: 'gcr-id', variable: 'SERVICE_ACCOUNT_KEY')]) {
						// sh 'gcloud auth activate-service-account --key-file=$SERVICE_ACCOUNT_KEY'
						// sh 'gcloud auth configure-docker europe-docker.pkg.dev'
						sh '''
						gcloud auth activate-service-account --key-file=$SERVICE_ACCOUNT_KEY
						gcloud auth configure-docker europe-docker.pkg.dev
						'''
            dockerImage.push("latest")
          }
        }
      }
    }
    stage('Deploying React.js container to Kubernetes') {
      steps {
        script {
          // kubernetesDeploy(configs: "deployment.yaml", "service.yaml")
					// -- Minikube --
					// sh('/var/jenkins_home/bin/kubectl --kubeconfig=$KUBECONFIG apply -f deployment.yaml')
					// sh('/var/jenkins_home/bin/kubectl --kubeconfig=$KUBECONFIG apply -f service.yaml')

					// sh('kubectl apply -f deployment.yaml')
					// sh('kubectl apply -f service.yaml')
					sh '''
					kubectl --kubeconfig=$KUBECONFIG apply -f deployment.yaml
					kubectl --kubeconfig=$KUBECONFIG apply -f service.yaml
					'''
        }
      }
    }
  }
}
