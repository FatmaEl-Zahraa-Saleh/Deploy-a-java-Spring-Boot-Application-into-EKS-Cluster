@Library('Jenkins-Shared_library')
def gv
pipeline {
    agent any
    environment{
        AWS_ACCESS_KEY_ID = credentials('jenkins-aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key-id')
        KUBE_NAMESPACE = 'development'		
        INGRESS_NAMESPACE = 'ingress-nginx'	
    }
    tools{
        gradle '8.10'
    }
    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout') {
            steps {
                checkout scm
            }
        }       
         stage('Lint') {
            steps {
                script {
                  // Run the gradle check task, which includes linting
                    //LintApp functions is avaliable in the jenkins-shared-library
                    
                    lintApp()
                }
            }
            post {
                always {
                    // Archive the linting report if any
                    archiveArtifacts artifacts: '**/build/reports/**', allowEmptyArchive: true
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    //testApp functions is avaliable in the jenkins-shared-library
                    testApp()
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh './gradlew sonar '
                }
            }
        }
        stage('Quality Gate') {
            steps {
                // Wait for SonarQube quality gate result
                timeout(time: 10, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    //buildJar functions is avaliable in the jenkins-shared-library
                    buildJar()
                }
            }
        }
        stage('Package') {
            steps {
                script {
                    //packageApp functions is avaliable in the jenkins-shared-library
                    packageApp()
                }
            }
        }
        stage('Build and Push Image '){
            steps {
                script {
                     //buildImage , pushImage functions is avaliable in the jenkins-shared-library,
                     // and they takes a varaiable 'image name'
                     buildImage 'my-spring-boot-app:v3'
                     dockerLogin()
                     pushImage 'my-spring-boot-app:v3'

                }
            }
        }
        stage('Deploying App to Development environment on EKS Cluster ') {
            steps {
                script{

                    // Create the development Namespace if it doesn't Exist 
            
                    sh 'kubectl create namespace ${KUBE_NAMESPACE} || true'     

                    // Create k8s secret to allow deployment resource to access dockerhub and pull the image 
                    withCredentials([usernamePassword(credentialsId: 'DockerHub_Credientials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                            
                            sh 'chmod +x ./scripts/CreateDockerHubSecret.sh'

                            sh './scripts/CreateDockerHubSecret.sh'
                        }
                    // deploying the spring boot application to EKS Cluster
                            sh 'chmod +x ./scripts/DeploytoEKS.sh'
                            
                            sh './scripts/DeploytoEKS.sh'
                }
            }
        }
        stage('Deploy Nginx Ingress Controller') {
            steps {
                script {

                    //|| true used not stop the pipeline if the development namespace is already Exist
                    sh '''
                    kubectl create namespace ${INGRESS_NAMESPACE} || true
                    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
                    helm repo update
                    helm install nginx-ingress ingress-nginx/ingress-nginx --namespace ${INGRESS_NAMESPACE} || true
                    '''
                }
            }
        }
        stage('Initialize Nginx Ingress Controller') {
            steps {
                sleep time: 20, unit: 'SECONDS'
                echo 'Nginx Ingress Controller initialization complete.'
            }
        }
        stage('Deploy Ingress Resource') {
            steps {
                script {
                    sh '''
                    kubectl apply -f ./kubernetes/ingress.yaml --namespace ${KUBE_NAMESPACE}
                    '''
                }
            }
        }
        stage('Fetch Load Balancer DNS') {
            steps {
                sleep time: 10, unit: 'SECONDS'
                echo 'Load Balancer initialization complete.'
            }
        }
      stage('Print DNS of Load Balancer') {
            steps {
                script {
                    def ingressName = "spring-boot-ingress"
                    def namespace = "development"
                    def loadBalancerDNS = sh(script: "kubectl get ing ${ingressName} --namespace ${namespace} -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'", returnStdout: true).trim()
                    echo "Load Balancer DNS: ${loadBalancerDNS}"
                }
            }
      }
    }
}
