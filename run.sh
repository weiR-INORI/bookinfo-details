#!/bin/sh
kubectl delete namespace student3-bookinfo-dev
kubectl delete namespace student3-bookinfo-uat
kubectl delete namespace student3-bookinfo-prd
gcloud container clusters get-credentials k8s --project zcloud-cicd --zone asia-southeast1-a
kubectl create namespace student3-bookinfo-dev
kubectl create namespace student3-bookinfo-uat
kubectl create namespace student3-bookinfo-prd
kubectl config set-context $(kubectl config current-context) --namespace=student3-bookinfo-uat
kubectl create secret generic registry-bookinfo --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson
kubectl create configmap bookinfo-uat-details-mongodb-initdb --from-file=databases/details_data.json --from-file=databases/script.sh
helm install -f k8s/helm-values/values-bookinfo-uat-details-mongodb.yaml bookinfo-uat-details-mongodb bitnami/mongodb
helm install -f k8s/helm-values/values-bookinfo-uat-details.yaml bookinfo-uat-details k8s/helm
kubectl config set-context $(kubectl config current-context) --namespace=student3-bookinfo-prd
kubectl create secret generic registry-bookinfo --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson
kubectl create configmap bookinfo-prd-details-mongodb-initdb --from-file=databases/details_data.json --from-file=databases/script.sh
helm install -f k8s/helm-values/values-bookinfo-prd-details-mongodb.yaml bookinfo-prd-details-mongodb bitnami/mongodb
helm install -f k8s/helm-values/values-bookinfo-prd-details.yaml bookinfo-prd-details k8s/helm
kubectl config set-context $(kubectl config current-context) --namespace=student3-bookinfo-dev
kubectl create secret generic registry-bookinfo --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson
kubectl create configmap bookinfo-dev-details-mongodb-initdb --from-file=databases/details_data.json --from-file=databases/script.sh
helm install -f k8s/helm-values/values-bookinfo-dev-details-mongodb.yaml bookinfo-dev-details-mongodb bitnami/mongodb
helm install -f k8s/helm-values/values-bookinfo-dev-details.yaml bookinfo-dev-details k8s/helm