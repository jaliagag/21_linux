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

```


