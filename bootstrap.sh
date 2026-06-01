#!/bin/bash

set -e

kind create cluster --config cluster.yml

kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/mysql-secret.yml
kubectl apply -f .infrastructure/mysql-init.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/statefulSet.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f configMap.yml
kubectl apply -f pv.yml
kubectl apply -f pvc.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f nodeport.yml
kubectl apply -f hpa.yml
