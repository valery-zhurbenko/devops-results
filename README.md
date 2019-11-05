# devops-results


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. There are a lot improvements TBD, especially specific cloud related.
This tutorial apply's on minikube. With couple small modifications can be used on local docker-desktop or any other kubernetes cluster.

### Prerequisites

* kafka cli installed on build machine (part of kafka installation "bundle")
* mvn installed on build machine
* `mysql-0.mysql`, `zoo-0` and `broker` are pointing to 127.0.0.1 on build machine. You can do this in /etc/hosts.
* access to `mysql-0.mysql:3306`, `zoo-0:2181` and `broker:9092` from build machine.
Since my cluster is on minikube my build machine is my MacOS laptop.

### Installing

A step by step series of examples that tell you how to get a development env running

1. run `kafka-mysql-deploy.sh`
it should install kafka cluster with 3 nodes, zookeeper with 2 nodes, mysql cluster with 3 nodes
2. to pass next steps like build and topic creation must be access to `mysql-0.mysql:3306`, `zoo-0:2181` and `broker:9092` from build machine.
fast way for minikube is just foward the ports:
```
kubectl -n myspace port-forward zoo-0 2181
```
```
kubectl -n myspace port-forward kafka-0 9092
```
```
kubectl -n myspace port-forward mysql-0 3306
```
3. run `consumer-build-deploy.sh`

The producer binds to http port 9000 and accepts post commands:

```http
POST http://localhost:9000/producer/?count=100
Accept: */*
Cache-Control: no-cache
```

where count is the number of items to publish. it will then read the number of items requested from the db and publish them to the kafka topic... 

## Running the tests
From you build machine be sure you have access to producer on port 9000.
Or `kubectl -n myspace port-forward producer 9000`...

```
curl -i -H "Accept: */*" -H "Cache-Control: no-cache" -X POST -d "value: test1" http://localhost:9000/producer/?count=100
```


### To Be Done:
* kafka cluster performance and availability - should be fully tested respectivately to cluster it is running on.
* mysql cluster - SaaS preferred.
* consumer and producer scaling should be defined but metrics, load balancing also depends on cloud provider.
* parameters, secrets (like mysql password) must move to separated service, like kubernetes-secrets. Or cloud provider service, which is preferred
