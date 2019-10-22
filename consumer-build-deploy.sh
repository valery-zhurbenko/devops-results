#!/bin/bash
#define variables
#be sure you can access kafka and mysql by this names from build machine, to pass tests, for minikube add them to /etc/hosts
MYSQL_HOST=mysql-0.mysql
BROKER_BOOTSTRAP_HOST=broker
#clone the code to compile consumer and producer
cd ..
git clone https://github.com/surielb/devops-test.git
cd devops-test

#replace values in config
sed -i '' s/localhost:3306/$MYSQL_HOST:3306/g consumer/src/main/resources/application.properties

sed -i '' s/localhost:9092/$BROKER_BOOTSTRAP_HOST:9092/g consumer/src/main/resources/application.properties

sed -i '' s/localhost:3306/$MYSQL_HOST:3306/g producer/src/main/resources/application.properties

sed -i '' s/localhost:9092/$BROKER_BOOTSTRAP_HOST:9092/g producer/src/main/resources/application.properties

#create topic
kafka-topics  --zookeeper zoo-0:2181 --create --topic charges --replication-factor 3 --partitions 3

#push mysql data
mysql -u root -h $MYSQL_HOST -u root -p'123456' < init.sql
#I assume you have kafka cli installed.. create the topic
#kafka-topics  --zookeeper localhost:2181 --create --topic charges --replication-factor 3 --partitions 3

#mvn build
mvn install -f ./common
mvn install -f ./producer
mvn install -f ./consumer

#docker build, example for minikube since local images used:
eval $(minikube docker-env)

docker build -t test/producer ./producer
docker build -t test/consumer ./consumer

cd ..

kubectl apply -f ./devops-results/producer-service.yaml

kubectl apply -f ./devops-results/producer-deployment.yaml


kubectl apply -f ./devops-results/consumer-service.yaml

kubectl apply -f ./devops-results/consumer-deployment.yaml



