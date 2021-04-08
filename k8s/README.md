# Kubernetes exam

## Docker

### Pelado Nerd

```console
docker ps 
# muestra contenedores corriendo
docker ps -a 
# muestra incluso los contenedores muertos
docker run hello-world 
# busca el contenedor hello world en la máquina - si no está lo descarga y lo corre
# busca en el docker registry, el repositorio público de docker
docker pull alpine 
# docker pull image - por defecto latest
docker pull alpine:3.7 
# descargar una versión específcia
docker run alpine:3.7 ls -l 
# correr un comando 
docker run -it alpine:3.7 sh 
# correr una interactive terminal
docker exec -it <containerID> sh 
# abrir un contenedor que está corriendo - antes tengo que saber cuál es el container ID con docker ps - exec: ejecutar un comando en el contenedor
#########
docker run -it ubuntu /bin/bash
	root@ee940ed3a156:/# apt-get update
	root@ee940ed3a156:/# apt-get install figlet
# ahora vamos a hacer un commit con la imagen modificada
docker ps -a 
# para ver los contenedores anteriores
docker commit <contID> 
# ponemos el ID de la imagen que queremos - docker commit ee940ed3a156
docker image ls | head 
# ver las 10 primeras imágenes en la compu - nosmuestra Repository Tag y ID
docker image tag <contID> <nombreParaAcordarnosMejor>:<version|tag>
docker run asdf figlet hola 
# nos debería correr con la imagen creada anteriormente

# Docker file
# Siempre arranca con FROM para indicar que se basa en otra imagen - no tienen interacciones los docker files
vi Dockerfile
# ----------
FROM ubuntu

RUN apt-get update && apt-get install figlet -y
# ----------

docker build -t midocker:1.1 .

docker image history <contID>
# muestra comandos originales del ubuntu

# al mismo archivo le agregamos
# ----------
RUN touch /tmp/hola
# ----------
# construimos otra imagen con el nuevo docker file actualizado
docker build -t midocker:1.2 .
# mucho más rápido pues debería estar cacheado
#########
docker run -d ngingx:1.15.7
# -d dejar coriendo un contenedor en background - debe correr un servicio, no un comando que entra y saletipo ls
docker exec -it <contID> <command>
# VOLÚMENES: en docker podemos montar en el contenedor un archivo que está en el host
docker stop <contID>
docker run -v <path of source file or complete dir to run>:<destionation inside container>:<read only? -ro> -d <contID> 
# docker run -v /home/jaliaga/Documents/GitHub/21_linux/k8s/volume/index.html:/usr/share/nginx/html/index.html:ro -d nginx:1.15.7
# -p expone un puerto desde el contenedor hacia el host
docker run -v <path of source file or complete dir to run>:<destionation inside container>:<read only? -ro> -p <puerto del host>:<a cuál apunta en el contenedor> -d <contID> 
# docker run -v /home/jaliaga/Documents/GitHub/21_linux/k8s/volume/index.html:/usr/share/nginx/html/index.html:ro -p 8080:80 -d nginx:1.15.7
# desde el host: curl localhost:8080 y...
# [jaliaga@osboxes k8s]$ curl localhost:8080
# <html>
# 	<body>
# 		<h1>Hola desde Dockercillio</h1>
# 	</body>
# </html>
# [jaliaga@osboxes k8s]$

#########
# pasar variables con -e
docker run -e MYSQL_ROOT_PASSWORD=miclave -e MYSQL_DATABASE=midb -v /home/jaliaga/mysql-data:/var/lib/mysql -d mysql:8.0.13
# docker-compose - crear todos los contenedores que necesito en un archivo yml
# ----------
version: '3.1'

services:

  wordpress:
    image: wordpress:php7.2-apache
    ports:
      - 8080:80
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: root
      WORDPRESS_DB_NAME: wordpress
    links:
      - mysql:mysql

  mysql:
    image: mysql:8.0.13
    command: --default-authentication-plugin=mysql_native_password
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_ROOT_PASSWORD: root
    volumes:
      - /home/jaliaga/docker/mysql-data:/var/lib/mysql

# ----------
# while on the folder where the docker-compose file is 
docker-compose up -d
#########
```

Networking en Docker

5 tipos de drivers en docker:

1. brdige: la interfaz de red del host le pasa toda la comunicación al contenedor
2. host: "bindea" todos los puertos en tu máquina y pasa derecho al contenedor. usa la misma IP que el host, no hay NAT, pasa derecho.
3. overlay: crear redes virtuales entre los contenedores - misma red para varios nodos. Facilita la comunicación entre los contenedores.
4. macvlan: asignar una MAC a un contenedor para que el contenedor corrar como si fuera otra máquina más 
5. none: desactiva el networking del contenedor

## udemy course

Installing Docker on ubuntu VM

```console
sudo su -
sudo apt install docker.io -y
```

docker commands

```console
docker version
docker run hello-world
docker run docker/whalesay cowsay boo
```

container orchestration: automatically scale up or down based on the load. App is highly available - user traffic is load balanced, scale up and down

Kubernetes: container orchestration technology used to orchestrate the deployment and management of hundreds and thousands of containers in a clustered environment.

- Node: a machine, physical or virtual, on which kubernetes is installed. a Node is a worker machine and that is _where containers will be launched by k8s_. nodes aka minions.
- cluster: a set of nodes grouped together - if one node fails, the app is still accessible. having multiple loads helps with sharing load.
- master: responsible for managing the cluster - another node with kubernetes installed on it. it's responsible for the actual orchestration of the containers on the worker nodes.

when you install kubernetes on a system you are installing:

- API Server: front end for kubernetes cluster
- etcd service or etcd key store: distributed reliable key value used by kubernetes to store all data used to manage the cluster. responsible for implementing locks within the cluster to ensure that there are no conflicts between the masters
- kubelet: the agent that runs on each node of the cluster. it's responsible for making sure that containers are running on the nodes as expected.
- container runtime: underlying software that is used to run containers - in this case, Docker.
- controller: the brains behind orchestration. responsible for noticing and responding when nodes go down. it makes decission to bring up new containers in such cases. 
- scheduler: distributing load accross multiple nodes. it looks for newly created containers.

| Master | Worker |
| ---- | ----- |
| kube-apiserver| kubelet agent|
| etcd | |
| controller | |
| scheduler | |
| | container runtime (Docker)|

`kubectl` : used to deploy and manage applications on a k8s cluster. to deploy an app: `kubectl run hello-minikube`. view information about a cluster: `kubectl cluster-info`. view all the nodes part of the cluster: `kubectl get nodes`

<https://kodekloud.com/courses/kubernetes-for-the-absolute-beginners-hands-on/lectures/5995932>

- `kubectl version`
- `kubectl get nodes -o wide` --> view human readable information
- `kubectl get pods` view avialable PODS
- `kubectl get pods -o wide` view pod ip add
- `minikube start`

PODS: the application is already developed on a docker image and on a docker repository. the k8s cluster is already setup.

objective of k8s: deploy application on containers on a set of machines configured as worker nodes on a cluster. k8s does not deploy containers directly on the worker nodes - containers are encapsulated into a k8s object, known as pods. a POD is a single instance of an application. a pod is the smallest object that you can create in k8s. 1 POD = 1 instance/container. to scale up you create new pods.

a single POD can have multiple containers but not of the same kind. there might be a helper container

- helper container: supporting task

helper and main container can communicate with each other using localhost port since they share the same network space. they can also share the same storage space. it's not that common to have 2 containers on a single pod

to deploy a pod: `kubectl run nginx --image nginx` --> it creates a docker container by creating a POD.

- `kubectl describe pods` : get more infor




















