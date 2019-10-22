#!/bin/bash
#download kubernetes kafka
cd ..
git clone https://github.com/valery-zhurbenko/kubernetes-kafka.git

#creating namespace
kubectl apply -f kubernetes-kafka/00-namespace.yml

#apply preferred scale configs, can be your own
#kubectl apply -k kubernetes-kafka/variants/dev-small/

#RBAC configs
kubectl apply -f kubernetes-kafka/rbac-namespace-default

#power up zookeeper
kubectl apply -f kubernetes-kafka/zookeeper

#power up kafka cluster
kubectl apply -f kubernetes-kafka/kafka

#power up mysql cluster
kubectl apply -f devops-results/mysql-configmap.yaml
kubectl apply -f devops-results/mysql-service.yaml
kubectl apply -f devops-results/mysql-stateful-set.yaml

sleep 60
echo "Done OK!"




