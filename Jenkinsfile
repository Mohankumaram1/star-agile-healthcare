

pipeline {
  agent any

  tools {
    maven 'M2_HOME'
  }

  stages {
    stage('CheckOut') {
      steps {
        echo 'Checkout the source code from GitHub'
        git branch: 'master', url: 'https://github.com/Mohankumaram1/star-agile-healthcare.git'
      }
    }
      stage('Package the Application') {
      steps {
        echo " Packaing the Application"
        sh 'mvn clean package'
            }
    }
   stage('Docker Image Creation') {
      steps {
        sh 'docker build -t mohankumar12/healthcare .'
            }
    }
     stage('DockerLogin') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'Docker-Login', passwordVariable: 'docker_password', usernameVariable: 'docker_login')]) {
        sh "docker login -u ${docker_login} -p ${docker_password}"
            }
        }
    } 
   stage('Push Image to DockerHub') {
      steps {
        sh 'docker push mohankumar12/healthcare'
            }
   }
    
    stage ('Configure Test-server with Terraform, Ansible and then Deploying') {
      steps {
        dir('my-serverfiles') {
          sh 'chmod 600 mohanm.pem'
          sh 'terraform init'
          sh 'terraform validate'
          sh 'terraform apply --auto-approve'
        }
      }
    }
      stage('Deploy to k8s'){
            steps{
                script{
                     kubernetesDeploy (configs: 'deploymentservice.yml' ,kubeconfigId: 'kubernetesconf')
                
       }
     }  
   } 
  }
  }
