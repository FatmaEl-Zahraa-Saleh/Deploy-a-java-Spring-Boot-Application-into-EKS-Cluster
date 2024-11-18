 #!/bin/bash


echo "deploying to development Environment EKS Cluster "

kubectl apply -f ./kubernetes/deployment.yaml -n $KUBE_NAMESPACE

kubectl apply -f ./kubernetes/service.yaml -n $KUBE_NAMESPACE
