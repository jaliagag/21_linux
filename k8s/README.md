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









```

