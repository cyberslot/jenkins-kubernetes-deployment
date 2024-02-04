pipeline {
    agent any
    
    environment {
        KUBECONFIG = credentials('test-minikube')
    }
    
    stages {
        stage('Install kubectl') {
            steps {
                sh 'curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.28.3/bin/linux/amd64/kubectl"'
                sh "chmod +x kubectl"
                sh 'mkdir -p $HOME/bin'
                sh 'mv kubectl $HOME/bin/'
            }
        }
        stage('Create Pod Manifest') {
            steps {
                script {
                    def podYaml = """
apiVersion: v1
kind: Pod
metadata:
  name: simple-pod
spec:
  containers:
    - name: nginx
      image: nginx:latest
"""
                    sh "echo '$podYaml' > pod.yaml"
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "/var/jenkins_home/bin/kubectl --kubeconfig=$KUBECONFIG apply -f pod.yaml"
                }
            }
        }
    }
}