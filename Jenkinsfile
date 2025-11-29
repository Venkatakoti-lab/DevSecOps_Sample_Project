pipeline {
  agent any
  tools { 
        maven 'Maven_3_8_4'  
  }
  environment{
	SONAR_TOKEN = credentials('SONAR_TOKEN')
  }
  stages{
	stage('CompileandRunSonarAnalysis') {
			steps {
					sh """
						mvn clean verify sonar:sonar \
						-Dsonar.projectKey=asgbuggywebapp84_buggy \
						-Dsonar.organization=asgbuggywebapp84 \
						-Dsonar.host.url=https://sonarcloud.io \
						-Dsonar.token=${SONAR_TOKEN}
					"""
				}
	}
	stage('RunSCAAnalysisUsingSnyk') {
			steps {		
				withCredentials([string(credentialsId: 'Snyk_token', variable: 'SNYK_TOKEN')]) {
					sh 'mvn snyk:test -fn'
				}
			}
	}
	stage('Build') { 
			steps { 
			withDockerRegistry([credentialsId: "dockerlogin", url: ""]) {
				script{
				app =  docker.build("asg")
				}
			}
			}
	}

	stage('Push') {
			steps {
				script{
					docker.withRegistry('https://747639505780.dkr.ecr.us-east-1.amazonaws.com/asg', 'ecr:us-east-1:aws-credentials') {
					app.push("latest")                                                                        
					}
				}
			}
	}
	stage('Kubernetes Deployment of ASG Bugg Web Application') {
		steps {
			withCredentials([file(credentialsId: 'kubelogin', variable: 'KUBECONFIG')]) {
			sh('kubectl delete all --all -n devsecops')
			sh ('kubectl apply -f deployment.yaml --namespace=devsecops')
			}
		}
	}
	stage ('wait_for_testing'){
		steps {
			sh 'pwd; sleep 180; echo "Application Has been deployed on K8S"'
			}
	}
	stage('RunDASTUsingZAP') {
		steps {
			withKubeConfig([credentialsId: 'kubelogin']) {
				sh('zap.sh -cmd -quickurl http://$(kubectl get services/asgbuggy --namespace=devsecops -o json| jq -r ".status.loadBalancer.ingress[] | .hostname") -quickprogress -quickout ${WORKSPACE}/zap_report.html')
				archiveArtifacts artifacts: 'zap_report.html'
			}
		}
	}
  }
}
