# CKA

## Links

- <https://www.cncf.io/certification/cka/>
- <https://github.com/cncf/curriculum>
- <https://www.cncf.io/certification/candidate-handbook>
- <http://training.linuxfoundation.org/go//Important-Tips-CKA-CKAD>
- <https://github.com/kodekloudhub/certified-kubernetes-administrator-course>

## Core Concepts

We're going to use an analogy of ships to understand the architecture of Kubernetes.

The purpose of Kubernetes is to host your applications in the form of containers in an automated fashion

so that you can easily deploy as many instances of your application as required and easily enable communication between different services within your application.
So there are many things involved that work together to make this possible.

So let's take a 10000 feet look at the Kubernetes architecture.

We have two kinds of ships.

1. _cargo ships_ that does the actual work of carrying containers across to sea and
2. _control ships_ that are responsible for monitoring and managing the cargo ships.

The **Kubernetes cluster** consists of a set of nodes which may be physical or virtual, on-premise or on cloud, that host applications in the form of containers. These relate to the cargo ships. In this analogy, the worker nodes in the cluster are ships that can load containers.

But somebody needs to load the containers on the ships and not just load plan how to load identify the right ships store information about the ships monitor and track the location of containers on the ships manage the whole loading process etc..

This is done by the control ships that host different offices and departments monitoring equipments communication equipments cranes for moving containers between ships etc.

The control ships relate to the master node in the Kubernetes cluster. The master node is responsible for managing the Kubernetes cluster storing information regarding the different nodes planning which containers cause where monitoring the notes and containers on them etc. _The Master node does all of these using a set of components together known as the control plane components_.

Now there are many containers being loaded and unloaded from the ships on a daily basis. And so you need to __maintain information about__ the different ships __what container is on which ship and what time it was loaded__ etc. **All of these are stored in a highly available key value store known as Etcd**. The Etcd is a database that stores information in a key-value format. We will look more into what Etcd cluster actually is what data is stored in it and how it stores the data in one of the upcoming lectures.

When ships arrive you load containers on them using cranes the cranes identify the containers that need to be placed on ships. It identifies the right ship based on its size its capacity the number of containers already on the ship and any other conditions such as the destination of the ship. The type of containers it is allowed to carry etc. So those are **schedulers in a Kubernetes cluster** as scheduler **identifies the right node to place a container on based on the containers**.

Resource requirements the worker nodes capacity or any other policies or constraints such as tents and tolerations or node affinity  rules that are on them. We will look at these in much more detail with examples and practice tests later in this course. We have a whole section on scheduling alone.

There are different offices in the dock that are assigned to special tasks or departments. For example the operations team takes care of ship handling traffic control etc. they deal with issues related to damages the routes the different ship state etc. The cargo team takes care of containers when continuous are damaged or destroyed. They make sure new containers are made available. You have these services office that takes care of the I.T. and communications between different ships. Similarly, in Kubernetes we have controllers available that take care of different areas.

The **node-controller** takes care of nodes. They're responsible for onboarding new nodes to the cluster handling situations where nodes become unavailable or get destroyed and the replication controller ensures that the desired number of containers are running at all times in your replication group.

So we have seen different components like the different offices the different ships the data store the cranes. But _how do these communicate with each other_? How does one office reach the other office and who manages them all at a high level.

**The kube-apiserver is the primary management component of kubernetes. The kube-api server is responsible for orchestrating all operations within the cluster**. _It exposes the Kubernetes API which is used by externals users to perform management operations_ on the cluster as well as the various controllers to monitor the state of the cluster and make the necessary changes as required and by the worker nodes to communicate with the server.

Now we are working with containers here. Containers are everywhere so we need everything to be container compatible. Our applications are in the form of containers the different components that form the entire management system. On the master nodes could be hosted in the form of containers.

The DNS service networking solution can all be deployed in the form of containers. So we need these **software that can run containers and that's the container runtime engine. A popular one being Docker. So we need Docker or it's supported equivalent installed on all the nodes in the cluster including the master nodes.** if you wish to host the control plane components as containers. Now it doesn’t always have to be Docker.

Kubernetes supports other run time engines as well like ContainerD or Rocket.

let's now turn our focus onto the cargo ships. Now every ship has a captain. The captain is responsible for managing all activities on these ships. The captain is responsible for liaising with the master ships starting with letting the master ship know that they are interested in joining the group receiving information about the containers to be loaded on the ship and loading the appropriate containers as required sending reports back to the master about the status of this ship and the status of the containers on the ship etc.

Now the captain of the ship is the **kubelet** in Kubernetes. **A kubelet is an agent that runs on each node in a cluster. It listens for instructions from the kube-api server and deploys or destroys containers on the nodes as required. The kube-api server periodically fetches status reports from the kubelet to monitor the state of nodes and containers on them.**

The kubelet was more of a captain on the ship that manages containers on the ship. But the _applications running on the worker nodes need to be able to communicate with each other_. For example you might have a web server running in one container on one of the nodes and a database server running on another container on another node. How would the web server reach the database server on the other node?

**Communication between worker nodes are enabled by another component that runs on the worker node known as the Kube-proxy service. The Kube-proxy service ensures that the necessary rules are in place on the worker nodes to allow the containers running on them to reach each other.**

So to summarize we have:

- **master** and **worker nodes**
  - on the master. We have the
    - **ETCD cluster** which stores information about the cluster
    - the **Kube scheduler** that is responsible for scheduling applications or containers on Nodes
    - We have different controllers that take care of different functions like the node control, replication, controller etc..
    - we have the **Kube api server** that is responsible for orchestrating all operations within the cluster.
  - on the worker node.
    - we have the **kubelet** that listens for  instructions from the Kube-apiserver and manages containers and
    - the **kube-proxy** That helps in enabling communication between services within the cluster.

![025](./assets/025.JPG)

So that's a high level overview of the various components.

### ETCD in k8s

In this lecture we will talk about ETCD’s role in kubernetes.

ETCD is a distributed reliable key-value store that is Simple, Secure & Fast. Used to store and retrieve small chunks of data, such as config data that requires fast read and write.

1. Download binaries
2. extract
3. run ETCD Service; it uses port 2379

etcdctl --> command to interact with etcd key-value store: `etcdctl set key1 value1`. to get data: `etcdctl get key1`.

The ETCD datastore stores information regarding the cluster such as the nodes, pods, configs, secrets, accounts, roles, bindings and others.

_Every information you see when you run the kubectl get command is from the ETCD server_. Every change you make to your cluster, such as adding additional nodes, deploying pods or replica sets are updated in the ETCD  server. Only once it is updated in the ETCD server, is the change considered to be complete.

Depending on how you setup your cluster, ETCD is deployed differently. Throughout this section we discuss about two types of kubernetes deployment. One deployed from scratch, and other using kubeadm tool.  

The practice test environments are deployed using the kubeadm tool and later in this course when we set up a cluster from scratch so it's good to know the difference between the two methods; if you set up your cluster from scratch then you deploy ETCD by downloading the ETCD binaries yourself, installing the binaries and _configuring ETCD as a service_ in your master node yourself. There are many options passed into the service a number of them relate to certificates (we will learn more about these certificates how to create them and how to configure them later in this course - we have a whole sectionon TLS certificates). The others are about configuring ETCD as a cluster.

We will look at those options when we set up high availability in kubernetes the only option to note for now is the **advertised client url**. This is the address on which ETCD listens. It happens to be on the IP of the server and on **port 2379, which is the default port on which etcd listens**. _This is the URL that should be configured on the kube-api server when it tries to reach the etcd server_.

If you setup your cluster using kubeadm then kubeadm deploys the ETCD server for you as a POD in the kube-system namespace. You can explore the etcd database using the _etcdctl_ utility within this pod. To list all keys stored by kubernetes, run the `etcdctl get` command like this. Kubernetes stores data in the specific directory structure the root directory is a registry and under that you have the various kubernetes constructs such as minions or nodes, pods, replicasets, deployments etc.

In a high availability environment you will have multiple master nodes in your cluster then you will have multiple ETCD instances spread across the master nodes. In that case, make sure to specify the ETCD instances know about each other by setting the right parameter in the ETCD service configuration. The initial-cluster option is where you must specify the different instances of the ETCD service.

etcdctl can interact with etcd server using 2 API versions, version 2 (default) and version 3.

| etcdctl v2 | etcdctl v3 |
| ------- |--------|
|etcdctl bakcup | etcdctl snapshot save |
| etcdctl cluster-health | etcdctl endpopint health |
| etcdctl mk | etcdctl get |
| etcdctl mkdir | etcdctl put |
| etcdctl set | |

to set the right version of API, set the environment variable ETCDCTL_API: `export ETCDCTL_API=3`. also, you must specify the path to certificate files so that ETCDCTL can authenticate to the ETCD API server. the certificate files are available in the etcd-master at:

- --cacert /etc/kubernetes/pki/etcd/ca.crt
- --cert /etc/kubernetes/pki/etcd/server.crt
- --key /etc/kubernetes/pki/etcd/server.key

specify etcdctl api version and path certificate files: `kubectl exec etcd-master -n kube-system -- sh -c "ETCDCTL_API=3 etcdctl get / --prefix --keys-only --limit=10 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt  --key /etc/kubernetes/pki/etcd/server.key"`

### kube-api server

In this lecture we will talk about the Kube-API server in kubernetes.

Earlier we discussed that the Kube-api server is the _primary management component in kubernetes_.  When you run a `kubectl command`, **the kubectl utility is infact reaching to the kube-apiserver**. The kube-api server first authenticates the request and validates it. It then retrieves the data from the ETCD cluster and responds back with the requested information.

You don’t really need to use the kubectl command line. Instead, you could also invoke the API directly by sending a post request.

let's look at an example of creating a pod. when you do that the request is authenticated first and then validated. In this case:

1. the API server creates a POD object without assigning it to a node,
2. updates the information in the ETCD server
3. updates the user that the POD has been created.
4. The scheduler continuously monitors the API server and realizes that there is a new pod with no node assigned
5. the scheduler identifies the right node to place the new POD on and communicates that information  back to the kube-apiserver.
6. The API server then updates the information in the ETCD cluster.
7. The API server then passes that information to the kubelet in appropriate worker node.
8. The kubelet then creates the POD on the node and instructs the container runtime engine to deploy the application image.
9. Once done,  the kubelet updates the status back to the API server and
10. the API server then updates the data back in the ETCD cluster.

A similar pattern is followed every time a change is requested. **The kube-apiserver is at the center of all the different tasks that needs to be performed to make a change in the cluster**.

To summarize, the kube-api server is responsible for Authenticating and validating requests, retrieving and updating data in ETCD data store. in fact, _kube-api server is the only component that interacts directly with the etcd datastore_. The other components such as the scheduler, kube-controller-manager & kubelet uses the API server to perform updates in the cluster in their respective areas.

If you bootstrapped your cluster using kubeadm tool then you don't need to know this but if you are setting up the hard way, then kube-apiserver is available as a binary in the kubernetes release page. Download it and configure it to run as a service on your kubernetes master node. The kube-api server is run with a lot of parameters. Throughout this section we are going to take a peak at how to install and configure these individual components of the kubernetes architecture.

You don't have to understand all of the options right now but I think having a high level understanding on some of these now will make it easier later when we configure the whole cluster and all of its components
from scratch.

The kubernetes architecture consists of a lot of different components working with each other, talking to each other in many different ways so they all need to know where the other components are. There are different modes of authentication, authorization, encryption and security. And that’s why you have so many options.

When we go through the relevant section in the course we will pull up this file and look at the relevant options.

A lot of them are certificates that are used to secure the connectivity between different components.

_The option ETCD-servers `etcd-servers=https://127.0.0.1:2379` is where you specify the location of the ETCD servers. This is how the kube-api server connects to the etcd servers._

So how do you view the kube-api server options in an existing cluster? It depends on how you set up your cluster.

If you set it up with kubeadm tool, kubeadm deploys the kube-api server as a pod in the kube-system namespace on the master node you can see the options within the pod definition file located at /etc/kubernetes/manifests folder.

In a non kubeadm setup, we can view the options of the kube-apiserver service located at /etc/systemd/system/kube-apiserver.service.You can also see the running process and the effective options by listing the process on the master node and searching for kube-apiserver `ps aux | grep kube-apiserver`.

### kube controller manager

we will talk about Kube Controller Manager.

As we discussed earlier, the kube controller manager manages various controllers in Kubernetes. A controller is like an office or department within the master ship that have their own set of responsibilities. Such as an office for the Ships would be responsible for monitoring and taking necessary actions about the ships. Whenever a new ship arrives or when a ship leaves or gets destroyed another office could be one that manages the containers on the ships they take care of containers that are damaged or full of ships.

So these officers are

1. continuously on the lookout for the status of the ships and
2. take necessary actions to remediate the situation.

**In the kubernetes terms a controller is a process that continuously monitors the state of various components within the system and works towards bringing the whole system to the desired functioning state**. For example the __node controller__ is responsible for monitoring the status of the nodes and taking necessary actions to keep the application running. **It does that through the kube-api server**.

The node controller checks the status of the nodes **every 5 seconds**. That way the node controller can monitor the health of the nodes - if it stops receiving heartbeat from a node the node is marked as **unreachable** but it waits for 40 seconds before marking it unreachable. after a node is marked unreachable it gives it five minutes to come back up - if it doesn’t, it removes the PODs assigned to that node and provisions them on the healthy ones if the PODs are part of a replica set

The next controller is the **replication controller**. It is responsible for monitoring the status of replica sets and ensuring that the desired number of PODs are available at all times within the set. _If a pod dies it creates another one_.

Now those were just two examples of controllers. There are many more such controllers available within kubernetes. Whatever concepts we have seen so far in kubernetes such as deployments, Services, namespaces, persistent volumes and whatever intelligence is built into these constructs it is implemented through these various controllers.

As you can imagine this is kind of the brain behind a lot of things in kubernetes. Now how do you see these controllers and where are they located in your cluster. _They're all packaged into a single process known as_ **kubernetes controller manager**. When you install the kubernetes controller manager the different controllers get installed as well.

So how do you install and view the kubernetes Controller manager? download the kube-controller-manager from the kubernetes release page. Extract it and run it as a service.
When you run it as you can see there are a list of options provided this is where you provide additional options to customize your controller.

Remember: some of the default settings for node controller we discussed earlier such as the node monitor period, the grace period and the eviction  timeout. These go in here as options.

There is an additional option called controllers that you can use to specify which controllers to enable. By default all of them are enabled but you can choose to enable a select few. So in case any of your controllers don't seem to work or exist this would be a good starting point to look at.

So how do you view the Kube-controller-manager server options? Again it depends on how you set up your cluster.

If you set it up with kubeadm tool, kubeadm deploys the kube-controller-manager as a pod in the kube-system namespace on the master node. You can see the options within the pod definition file located at etc/kubernetes/manifests folder.

In a non-kubeadm setup, you can inspect the options by viewing the kube-controller-manager service located at the services directory. You can also see the running process and the effective options by listing the process on the master node and searching for kube-controller-manager `ps aux | grep kube-controller-manager`.

### kube scheduler

Only responsible for deciding which pod goes on which nodes; it doesn't place the pods on the nodes. that's the job of the kubelet; the kubelet, the captain of the ships, is who creates the pods on the ships.

Scheduler is used to decide which nodes the pods are placed on, depending on certain criteria. for instance pod dedicated to a specific application within the cluter.

the scheduler looks at each pods and tries to find the best node for it. for example, cpu requirements. the scheduler

1. filters the nodes that do not fit the profile for a pod
2. ranks the nodes to identify the best fit for the pod - priority function to give a score to the node. it ranks nodes higher based on the amount of resources that would be free if the pod is placed on the node (say, requirement is 10 cpus, and there are 2 nodes, **A** with 12 nodes and **B** with 16 nodes; node B would be ranked higher because there would be 6 free cpus in case the 10 cpu pod is assigned to it)

Installing - download, isntall and run as a service.

### kubelet

the kubelet in the worker nodes registers the nodes with the k8s cluster. when it receives instruction to load a container or pod on the nodes, it requests the container runtime engine to pull the required image and run an isntance of it.

The kubelet also monitors the status of the POD and containers in it and reports to the kube-api server.

- register the node
- create PODs
- monitor node and PODs

installing kubectl:

- kubeadm installation method: kubeadm k8s deployment does not install the kubelet.
- manual install - kubelet has to be manually isntalled always - download installer, extract it and run it as a service. `ps aux | grep kubelet`

### kube proxy

in a k8s cluster, any pod can reach any other pod - this is accomplished by using a pod networking solution to the cluster. a pod network is an internal virtual network that spans accross all the nodes in the cluster to which all the pods connect to.

it's better to use a service, which maintains the ip address, to ensure communication between nodes and pods.

kube-proxy is a process that runs on each node in the k8s cluster. it's job is to look for new services and each time a new service is created, it creates the appropriate rule to forward traffic to those services to the backend pods by using ip table rules.

download the binaries, install and run as a service. the kubeadm tool deploys kube proxy as a pod, as a daemon set.

### pod

containers are encapsulated into a k8s object known as PODs. a POD is a single instance of an application. a POD is the smallest object that you can create in k8s.

PODs usually have a one to one relationship with containers running the app. you do not add additional containers to an existing POD to escale your app; you create a new POD - or delete the POD (escale down). from the outside to the in

1. cluster
2. node
3. pod
4. container

a single POD can have multiple containers, but not multiple containers of the same kind. we might have _helper containers_. supporting tasks for app, processing user data, a file... if a new POD is created, helper container is created as well.

containers can communicate with each other using localhost (loopback nic), same network space, and storage space.

how to deply pods: `kubectl run nginx --image nginx`. it creates a pod and deploys an image of the nginx docker image. it gets the image from the dockerhub repository. it can also be configured to pull images from a local repository.

`kubectl get pods` -- see pods and status - `kubectl describe pod <podname>`

### pods with yaml

k8s uses yaml files as inputs for the creation of k8s objects. required structure:

- apiVersion <-- version of the k8s api version we are using to create the object - regularly for working for pods `v1`; for services `v1`, replicaSet `apps/v1`, deployment `apps/v1`
- kind <-- type of object we are trying to create - Pod, Service, ReplicaSet, Deployment
- metadata <-- data about the object, it's *name*, *labels*, etc... form of dictionary
- spec <-- additional info about the object we are creating.

Once the file is done `kubectl create -f <file>`

```yml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
    - name: nginx-container
      image: nginx
    # - name: backend-container
    #   image: redis
```

### replica sets

controllers: the processes that monitor k8s objects and respond accordingly. **Replicatoin Controller**. it helps to run multiple instance of a single pod in the k8s cluster, thus providing HA. even if you have a single pod the replication controller can help by automatically bringing up a new pod when the existing pod fails. the replication controller ensures that the specified number of pod are running at all times.

RC is also used to share the load between containers - RC can create pods on other nodes as well. The replication controller is older technology, being replaced by **replica sets**. replica sets is the new recommended way of setting up replication.

creating a replication controller:

```yml
apiVersion: v1
kind: ReplicationController
metadata:
  name: myapp-rc
  labels:
    app: myapp
    type: front-end
spec:
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
    spec:
      containers:
        - name: nginx-container
          image: nginx
  replicas: 3
```

- `kubectl create -f <file>`
- `kubectl get replicationcontroller`

what is a replica? a copy of a pod

```yml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: myapp-replicaset
  labels:
    app: myapp
    type: front-end
spec:
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
    spec:
      containers:
        - name: nginx-container
          image: nginx
  replicas: 3
  selector:
    matchLabels:
      type: front-end
```

mayor difference with replication controller is the "selector" field: it identifies what pods fall under it. RS can also manage pods that were not created as part of the rs creation (pods created before applying the replica set). replica sets can be used to monitor existing pods.

- `kubect get replicaset`

Labels and selectors

**The role of the replica set** is to monitor the pod and in case any on them were to fail, deploy new ones. the rs is a process that monitors the pod. the replica set knows which pod to monitor through the labels attached to pods, defined under the selector field.

to escale the number of replicas, we can simply update the rs config file `kubectl replace -f <file>`; to do this task manually, we can run `kubectl scale --replicas=6 <file>` or `kubectl scale --replicas=6 <type> <rsName>`<-- this does not update the rs definition file.

We can also use `kubectl edit <replicasetName>`, update the configuration there and then delte de pods; as they are being deleted and recreated, they will pick up the new configuration.

### deployments

deployments are useful for

- deploying/creating new instances of an application
- updating an application (rolling updates)
- rolling back an update
- multiple changes to the environment (updating and creating new instances) - apply changes after a pause, then continue

deployments are k8s objects that are higher than replicasets. it allows for seamless update of the app.

creating a deployment through a definition file (similar to replica set):

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  labels:
    app: myapp
    type: front-end
spec:
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
        type: front-end
    spec:
      containers:
        - name: nginx-container
          image: nginx
  replicas: 3
  selector:
    matchLabels:
      type: front-end
```

`kubectl create -f <deploymentFile>` <<-- the deployment creates a replica set (get deployments = 1, get replicasets = 1) which create pods.

`kubectl get all`

<https://linuxhandbook.com/kubectl-apply-vs-create/>

### creating yml files on the run

using `kubectl run` command can help in generating a yaml template. if your were asked to create a pod or deployment with specific name and image you can simply run the `kubectl run` command.

<https://kubernetes.io/docs/reference/kubectl/conventions/>

- creating an nginx pod: `kubectl run nginx --image=nginx`
- generate POD manifes yaml file (`-o yaml`) - don't create it (`--dry-run`): `kubectl run nginx --image=nginx --dry-run=client -o yaml`
- create a deployment: `kubectl create deployment --image=nginx nginx`
- generate deployment yaml file (`-o yaml`). don't create it (`--dry-run`): `kubectl create deployment --image=nginx nginx --dry-run=client -o yaml`
- generate deployment yaml file (`-o yaml`). don't create it (`--dry-run`) with 4 Replicas (`--replicas=4`): `kubectl create deployment --image=nginx nginx --dry-run=client --replicas=4 -o yaml > nginx-deployment.yaml`

we can create a new file and make necessary changes to it.

```console
root@controlplane:~# kubectl create deployment --image=httpd:2.4-alpine httpd-frontend --dry-run=client --replicas=3 -o yaml > own-file.yaml
root@controlplane:~# 
root@controlplane:~# 
root@controlplane:~# 
root@controlplane:~# 
root@controlplane:~# cat own-file.yaml 
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: httpd-frontend
  name: httpd-frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: httpd-frontend
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: httpd-frontend
    spec:
      containers:
      - image: httpd:2.4-alpine
        name: httpd
        resources: {}
status: {}
root@controlplane:~# kubectl create deployment --image=httpd:2.4-alpine httpd-frontend ^Creplicas=3 -o yaml > own-file.yaml
root@controlplane:~# kubectl get deployments
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment-1          0/2     2            0           5m26s
frontend-deployment   0/4     4            0           17m
root@controlplane:~# kubectl create deployment --image=httpd:2.4-alpine httpd-frontend --replicas=3 -o yaml > own-file-r.yaml
root@controlplane:~# kubectl get deployments
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment-1          0/2     2            0           5m52s
frontend-deployment   0/4     4            0           17m
httpd-frontend        0/3     3            0           4s
root@controlplane:~#
```

### namespaces

_default_ is the namespace that creates k8s. k8s creates a set of pods for internal purposes (networking solution, dns...) to isolate them from the user on another namespace named _kube-system_. a third namespace is created called _kube-public_; this is where resources that should be made available to all users are created.

resources on namespaces are isolated.

namespaces can have different sets of policies assigned, to define who can do what. you can also assign quotas/limits of resources to the namespaces.

resources within a namespace can refer to each other simply by their names (`mysql.connect("db-service"`). a pod can reach a resource on another namespace - we must append the name of the namespace to the name of the service (`mysql.connect("db-service.dev.svc.cluster.local")` <<<--- connecting from, say, default ns to dev ns). we can access the resources because a DNS entry is created when the service is created.

| db-service | dev | svc | cluster.local |
| ---------- | ---- |---- |--------- |
| service name | namespace | service | domain |

- to list pods on another ns: `kubectl get pods --namespace=<nsName>`
- create a pod on another ns: `kubectl create -f <file> --namespace=<nsName>` we can move this option directly to the pod definition file; under **metadata**, `namespace: dev` as a sibling of **name**. this ensures that resources are created on the same ns consistently.

creating a ns definition file

```yml
apiVersion: v1
kind: Namespace
metadata:
  name: dev
```

`kubectl create -f <fileName>`

Another way of creating a ns is by running `kubectl create namespace <nsName>`

to switch to another namespace: `kubectl config set-context $(kubectl config current-context) --namespace=dev`

to view pods on all ns: `kubectl get pods --all-namespaces`

contexts are used to manage multiple clusters and environments from the same management system.

to limit resources in a ns, create a _resource quota_

```yml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: dev
spec:
  hard:
    pods: "10"
    requests.cpu: "4"
    requests.memory: 5Gi
    limits.cpu: "10"
    limits.memory: 10Gi
```

`kubectl create -f <file>`

- `kubectl get ns`
- `kubectl -n research get pods` --> `-n` for namespace name

### services

services enable communication between components and outside the app. they help us connect apps with other apps/users.

![026](./assets/026.JPG)

services are k8s objects with many uses. one of then is to listen to a port on the node and forward requests on that port to a port on the pod running the web app.

![027](./assets/027.JPG)

we can't reach the web page on the POD, which has a private IP 10.244.0.2; we can create a service on the node that listens to requests on port XXX; once the node reciebes a request on a certain port, the service will "translate" the address and reach the pod.

this is known as a **node-port** service - the service listens to a port on the node and forwards requests to the POD.

1. node-port: the service makes an internal port accesible on a port on the node
2. clusterIP: the service creates a virtual IP inside the cluster to enable communication between services, for instance, front end and back-end servers
3. load balancer: it creates a loand balancer for our app in supported cloud providers.

#### NodePort

in node port there are 3 ports involved:

1. the port on the POD where the web-server is running (port 80) <-- it is referred to as the **target port**
2. port on the service itself - it is simply referred to as the port; this naming convention takes the POV of the _service_. the service has its own ip, known as the **clusterIP** of the service.
3. the port on the node, which we use to reach it externally - known as the **NodePort**. by default port range for NodePort is between 30000 and 32767

creating a service:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  type: NodePort # could be ClusterIP or LoadBalancer
  ports:
  - targetPort: 80
    port: 80 # MANDATORY
    nodePort: 30008
  selector: # we use labels used to create the pod
    app: myapp      # these two fields are pulled from the POD def file, metadata > labels
    type: front-end # having app and type creates the link between the service and the POD
```

![028](./assets/028.JPG)

nodeport has a builtin _random_ algorythm to distribute load in case there are multiple PODs; it also has SessionAffinity.

what happens when the app is distributed across _nodes_: k8s creates a service that spans across all the nodes in the cluster and maps the target port to the same nodeport on all the nodes of the cluster. this way allows you to access the application from any node in the cluster using the same port number.

![029](./assets/029.JPG)

#### ClusterIP

we can't rely on POD IP's to ensure communication between apps, since they are constantly being created.

clusterIP is a k8s service that allows us to group IPs together on a single interface. each ip gets an ip and name assigned to it inside the cluster and that's the information that should be used by other pod to access the service.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: back-end
spec:
  type: ClusterIP # default service
  ports:
    - targetPort: 80  # where the backend is exposed
      port: 80  # where the service is exposed
  # to link the service to a set of ports we use selector
  # copy the label from pod def file
  selector:
    app: myapp
    type: back-end
```

#### LoadBalancer

cloud providers have native custom load balancers

```yml
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  type: LoadBalancer # default service
  ports:
    - targetPort: 80
      port: 80
      nodePort: 30008
```

### imperative vs declarative

in IaC there are two main approaches, imperative and declarative.

- imperative: specifying what and how to do it. set of instruction, step by step. checks need to be done manually.
  - `kubectl run --image=nginx nginx`
  - `kubectl create deployment --image=nginx nginx`
  - `kubectl expose deployment nginx --port 80`
  - `kubectl edit deployment nginx`
  - `kubectl scale deployment nginx --replicas=5`
  - `kubectl set image deployment nginx nginx=nginx:1.18`
  - `kubectl create -f <file>`
  - `kubectl replace -f <file>`
  - `kubectl delete -f <file>`
- declarative: you specify the final state; what to do. we state what we need. checks are done by the tool. updating only the config file. the declarative approach involves creating a set of files indicating the _expected state of app/services_ on the k8s cluster and a simple `kubectl apply -f <file>`, k8s should be able to determine how to reach the indicated state. kubectl apply for creating, managing and updating. this command will look at the existing configuration and figure out what changes need to be made to the system.

within the imperative approach, there are two "ways":

1. running imperative commands to create or create objects - quick, no need to write yaml file. limited functionality, long commands
2. creating objects with definition or manifest files

best practice: update the configuration file, then `kubectl replace -f <modifiedConfigFile>` <<<---- this is imperative applies.

insted of using the `kubectl replace`, we use `kubectl apply` command - this commands knows NOT to create an object if it already exists (with _replace_ if the object already exists, we will get an error). we can also input an entire directory so that all definition files on the directory are created.

when we want to make a change, we use `kubectl apply -f <filename>` and it knows that there is already a process with that information, but it looks for any changes to what is actually running and it _updates the object_.

- `--dry-run`: as soon as the command is run, the resource will be creted
- `--dry-run=client`: if you simply want to test your command - this will not crete the resource, instead, it will etll you whether the resource can be created and if your command is right.
- `-o yaml`: tils will output the resource definition in yaml format on the screen

- creating a pod: `kubectl run nginx --image=nginx`
- creating a pod definition file (but not actually doing it): `kubectl run nginx --image=nginx --dry-run=client -o yaml`
- creating a deployment: `kubectl create deployment --image=nginx nginx`
- creating a deployment definition file: `kubectl create deployment --image=nginx nginx --dry-run=client -o yaml`
- create deployment with 4 replicas: `kubectl create deployment nginx --image=nginx --replicas=4` - to scale the deployment: `kubectl scale deployment <depnam> --replicas=3`
- save the yaml def file to a file: `kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml`
- creating a service: `kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml` <<<--- this will automtically use the pod's labels as selectors. another way of doing this is `kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml` (this will not use the pods labels s selectors, instead, it will assume selectors as **app=redis**)
- `kubectl run custom-nginx --image=nginx --port=8080`
- `ubectl create deployment redis-deploy --namespace=dev-ns --image=redis --replicas=2`
- `kubectl run httpd --image=httpd:alpine --port=80 --expose`

- <https://github.com/kubernetes/kubernetes/issues/46191>
- <https://kubernetes.io/docs/reference/kubectl/conventions/>

```console
kubectl run redis --image=redis:alpine --labels="tier=db"
kubectl create svc clusterip redis-service --tcp=6379   
kubectl create deploy webapp --image=kodekloud/webapp-color --replicas=3
kubectl run custom-nginx --image=nginx --port=8080
kubectl create ns dev-ns
kubectl create deploy redis-deploy --namespace=dev-ns --image=redis --replicas=2
kubectl run httpd --image=httpd:alpine --port=80 --expose
```

### kubectl apply

it's used to work on a declarative way; this command takes into account the **local configuration file**, **the live object definition file on k8s** and **the last applied configuration**.

if the object does not already exists, the object is created. when the object is created, an object, similar to the definition file we created locally, is created locally, but with additional fields to store the status of the object. this is the live configuration of the object in the cluster.

when we we create an object with kubectl apply, the local configuration file is converted into a json format and it is then stored as the last applied configuration - going forward, the three files are compared to identify what changes are to be made to the live object.

1. local file updated
2. `kubectl apply -f <file modified>`
3. the new values are compared to the live configuration file; if there is a difference, the live version is updated with the new value
4. json last applied configuration is updated

the last applied configuration file is used to "figure out" what fields are/were removed from the local file, the history of the file configuration.

- <https://kubernetes.io/docs/tasks/manage-kubernetes-objects/declarative-config/>

the last applied configuration information is stored within the live object configuration file as an annotation named _last-applied-configuration_. kubectl create or replace do not store the last applied configuration.

## Scheduling

manual scheduling. ervery pod has a field called **nodeName** that by default it is not set. the scheduler goes over all the pods and looks for those that do not have this property set. those are the candidates for scheduling.

it then identifies the right node for the pod and sets the value of the property/field **nodeName** to be the corresponding node by creating a binding object.

if there is no scheduler, the pods remain in a status pending. we can manually assign pods to nodes. we can simply hardcode the field nodeName on the pod def file. we can only specify the node name when the pod is being created. k8s won't allow you to modify the nodeName property of a pod.

we can create a binding object and send a post request to the pods binding API

```yaml
apiVersion: v1
kind: Binding
metadata:
  name: nginx
target:
  apiVersion: v1
  kind: Node
  name: node02 # name of the node
```

then send a post request to the pod's binding API with the data set to the binding object in JSON format: `curl --header "Content-Type:application/json" --request POST --data '{"apiVersion":"v1", "kind": "Binding" } http://$SERVER/api/v1/namespaces/default/pods/$PODNAME/binding/'`

labels and selectors: standard method to group things together. also to apply filters based on criteria.

- labels are properties attached to items - undermetadata, create a section called _labels_.
- selectors help you filter the items. `kubectl get pods --selector app=App1`

Replica sets: to link the replicaset to the pod, we configure the selector field under the replica set > spec > selector > matchLabels (defined as) > app: App1 (as the pods will be defined). it's the same for other objects, say services. services use the selector to match the _pods_ in the replica set def file.

Annotations: build version, names, emails...

- `kubectl get pods --show-labels`
- `kubectl get pods --selector env=dev --no-headers | wc -l` ; `kubeclt get pods -l env=dev`
- `kubectl get all --selector env=prod --no-headers | wc -l`
- `kubectl get pod --selector env=prod,bu=finance,tier=frontend`

### taints and tolertions

pod to node relationship, what pod goes to what node. taints and tolerations are used to set restrictions on what nodes can pods be scheduled.

when pods are created, the k8s scheduler tries to put them on the available worker nodes.

say we want pods to go or _not_ go to a certain node.

first, we prevent all pods from being placed on the node by placing a _taint_ on the node. by default, pods don't have tolerations which means that, unless specified otherwise, no pod can tolerate any taint, no pods can be placed on the node.

then we have to enable pods by specifying which pods are tolerant. we had a toleration to a pod for a specific taint.

- taints are set on nodes
- tolerations are set on pods

the taint is a key-value pair

`kubectl taint nodes node-name key=value:taint-effect` the taint effect defines what happens to the pod if they do not tolerate the taint. there are three _taint_ effects:

1. NoSchedule: the pod will not be scheduled.
2. PreferNoSchedule: the system will try to avoid placing a pod on the node (but that is not guaranteed)
3. NoExecute: new pods will not be scheduled on the pod and existing pods on the node will be evicted if they do not tolerate the taint.

`kubectl taint nodes node1 app=blue:NoSchedule`

to add a toleration to pod throught the definition file, add a section called tolerations under _spec_:

```yaml
  tolerations:
  - key: "app"
    operator: "Equal"
    value: "blue"
    effect: "NoSchedule"
```

taints and toleratiosn are meant to restrict nodes from accepting certain pods. a node might be configured to accept only a certain toleration, but that does not mean that the pod _will always_ be placed on that node if there are no tains applied to the other nodes.

tainsts and tolerations do not tell the pod to go to a particular node. it tells the node to only accept pods with certain tolerations.

if the requirement is to restrict a pod to a certain node, it is accomplished through a concept known as _node affinity_.

as regards master nodes: the scheduler does not schedule any pods on the master node because when the k8s is being set up, a taint is applied automatically that prevents any pods from being placed on the node.

`kubectl describe node kubemaster | grep Taint`

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: bee
spec:
  containers:
    - name: bee
      image: nginx
  tolerations:
    - key: "spray"
      operator: "Equal"
      value: "mortein"
      effect: "NoSchedule"
```

- `kubectl run bee --image=nginx --restart=Never --=client -o yaml > bee.yaml`
- `kubectl explain pod --recursive | less` --> see options for pods
- `kubectl get pod -o wide`

remove a taint: `kubectl taint nodes node1 key1=value1:NoSchedule-`

if we don't know why a pod is not being created, we can use `kubectl describe pod <podName>` to search for any warnings or errors.

### node selectors | node affinity

- node selectors: simpler, in the pod def file we add a new property called nodeSelector

```yaml
  nodeSelector:
    size: Large
```

size: Large - _labels_ assigned to the nodes. the scheduler uses these labels to match and identify the right node to place the nods on.

labeling a node: `kubectl label nodes <nodeName> <labelKey>=<labelValue>` or on the node definition file. after labelling the node we can create the pod using the nodeSelector attribute.

limitations: it's simple, not much logic (either, or)

- node affinity: ensure that pods are hosted on a particular node. advanced capability to limit pod placement on specific pods.

place the pod either on Large or Medium sized pods - under _spec_

```yaml
spec:
  affinity:
    nodeAffinity:
     requiredDuringSchedulingIgnoredDuringExecution:
       nodeSelectorTerms:
       - matchExpressions:
         - key: size
           operator: In
           values:
           - Large
           - Medium
########################################################
    - matchExpressions:
        - key: size
    operator: NotIn
    values:
    - Small
########################################################
    - matchExpressions:
        - key: size
    operator: Exists
# the exists operator will check if the label "size" exists on the node
# you don't need the value section for that - it does not compare the values
```

what if node affinity cannot match a node with the given expression? this is solved by the long sentence (line 810). it is called the node affinity type - it defines the behaviour of the scheduler as regards node affinity and the stages in the life cycle of the pod

- Available
  - requiredDuringSchedulingIgnoredDuringExecution:
  - preferredDuringSchedulingIgnoredDuringExecution:
- Planned
  - requiredDuringSchedulingRequiredDuringExecution: this is still being develop - it will evict any pods upon a change in the environment (say a label).

- DuringScheduling: state when a pod does not exist and is created for the first time. when first created, the affinity rules created are considered to place a pod on the right node. what if we forgot to label the node? that's where the type of node affinity
  - Required: the scheduler will mandate that the pod be placed on the node with the given affinity rules. if it cannot find one, the pod will not be scheduled. this type will be used when the placement of the pod is _crucial_.
  - preferred: the placement of the pod is not as important as running the load itself. in case of a matching node not found, the scheduler will simply ignore node affinity rules and place the pod on any available node.
- DuringExecution: a pod has been running and a change is made to the environment that affects node affinity (label of a node, for instance). these changes will not impact the node once they have been scheduled (provisioned?).

![30](./assets/030.png)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: red
  name: red
spec:
  replicas: 2
  selector:
    matchLabels:
      app: red
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: red
    spec:
      containers:
      - image: nginx
        name: nginx
        resources: {}
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
              nodeSelectorTerms:
              - matchExpressions:
                - key: node-role.kubernetes.io/master
                  operator: Exists
###############################################################
      labels:
        app: blue
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: color
                operator: In
                values:
                - blue
      containers:
      - image: nginx
        imagePullPolicy: Always
        name: nginx                   
```

- `kubectl get nodes <nodeName> --show-labels`
- `kubectl label nodes <nodeName> <key>=<value>`
- `kubectl scale deployment <depName> --replicas=<#>`

### node affinity vs taints and toleration

to ensure that pods go to a especific node, taints/toleration and nodeAffinity are used in combination.

- nodes: taints and labels
- pods: toleration and selectors

### resource allocation

scheduler takes into consideration the amount of resources each pod requires and those available on the nodes. if there are no more resources available, k8s avoids scheduling the pod - the pod will remain in pending state. checking the events will show the reason (insufficient cpu, memory...).

- cpu: default 0.5 cpu*
- mem: default 256 Mi*
- disk

*Minimum resource request

default values can be modified on the pod/deployment-definition files. also, for the pod to pick up those defaults you must have first set those as default values for request and limit by creating a _LimitRange_ in that **namespace** (<https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource>):

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: mem-limit-range
spec:
  limits:
  - default:
      memory: 512Mi
    defaultRequest:
      memory: 256Mi
    type: Container
# https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/

apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-limit-range
spec:
  limits:
  - default:
      cpu: 1
    defaultRequest:
      cpu: 0.5
    type: Container
# https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-default-namespace/
```

0.1 count of cpu can also be expressed as 100m. 1 count of cpu = 1 vcpu. docker container has no limit to the amount of resources it can consume on a node. unless otherwise specified, k8s limits containers to 1vcpu on the node. as regards mem, the default limit is set to 512 Mi

under _containers_ add resources:

```yaml
spec:
  containers:
  - name: asdf
    image: nginx
    ports:
      - containerPort: 8080
    resources:
      requests:
        memory: "1Gi"
        cpu: 1
      limits:
        memory: "2Gi"
        cpu: 2
```

limits are set for each _container_ within the _pod_.

execeeding the limits

- cpu: k8s throttles the cpu so that it doesn't go beyond the specified limit
- memory: containers can use more memory than its limit. if it _constantly_ tries to (and consumes?) consume more memory than it limits, the pod is terminated.

With Deployments you can easily edit any field/property of the POD template. Since the pod template is a child of the deployment specification,  with every change the deployment will automatically delete and create a new pod with the new changes. So if you are asked to edit a property of a POD part of a deployment you may do that simply by running the command

`kubectl edit deployment my-deployment`

### Daemon sets

daemon sets are similar to replica sets since they help in creating multiple instances of pods but they run a copy of the pod con each node of the cluster. whenever a new node is added to the cluster, a new pod is added to the node:

![31](./assets/031.PNG)

ds ensures that at least one copy of the pod is always present in all nodes in the cluster.

ds perfect monitoring agent, logs viewer. DS are applied at the cluster lvl (?); also used for deploying kube-proxy, and networking

ds-def.yml

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: monitoring-daemon
spec:
  selector:
    matchLabels:
      app: monitoring-agent
  template:
    metadata:
      labels:
        app: monitoring-agent
    spec:
      containers:
      - name: monitoring-agent
        image: monitoring-agent
```

to describe a name space we have to specify the namespace: `--namespace=<nsName>`

An easy way to create a DaemonSet is to first generate a YAML file for a Deployment with the command `kubectl create deployment elasticsearch --image=k8s.gcr.io/fluentd-elasticsearch:1.20 -n kube-system --dry-run=client -o yaml > fluentd.yaml`. Next, remove the replicas and strategy fields from the YAML file using a text editor. Also, change the kind from **Deployment** to **DaemonSet**.

### static pods

the kubelet relies on the kubeapi server for instruction on which pods to load on its node. we can configure the kubelet to create pods on the definition file stored on a directory `/etc/kubernetes/manifests`. it checks constantly to see if there are new files. kubelet can also restart the pod in case the pod crashes. if changes are made on the file, the pod is also updated. if the file is removed, the pod is deleted. these are static pods.

no replica sets, nor daemonsets, nor services can be created this way. only pods.

kubelet works at pod level and only understands pods.

we can change the location of where pod are stored. we have to modify the kubelet service line that contains `--pod-manifest-path=<xxxx>`. we replace this line with an external yaml file to indicate where these files will be stored: `--config=kubeconfig.yaml`. on that file `staticPodPath: /etc/kubernetes/manifests`.

kubeadm uses a similar architecture. it creates pods for each service, and they have -controlplane added to their name (rather than the typical static).

when in a cluster, the kubelet can still create static pods, while receiving orders to create pods from the kubeapi. the api server will be able to see the static pod. when the kubelet creates a static pod, if part of a cluster, it also creates a mirrored object in the kubeapi server; when we check from the kubeapi server, we see a read-only image of the pod; we can view details of the pod, but we can't edit anything.

![32](./assets/032.PNG)

Run the command `ps -aux | grep kubelet` and identify the config file - `--config=/var/lib/kubelet/config.yaml`. _Then check in the config file for staticPodPath_.

`kubectl run static-busybox --image=busybox --command sleep 1000 --dry-run=client --restart=Never -o yaml > file.yaml`

### multiple schedulers

when creating a pod or deployment you can instruct k8s to have the pod scheduled by a specific scheduler. we can choose the scheduler name when creating it (**--scheduler-name=scheduler01**).

![33](./assets/033.PNG)

- leader-elect=true: choosing a leader who will have the final say.

`schedulerName: <schedulerName>` - same level as containers under spec

`kubectl get events`: lists all the events on the current nameSpace. to view the logs of the scheduler, we can check the logs of the pod: `kubectl logs my-custom-scheduler --name-space=kube-system`

lab

- `kubectl -n <nameSpace> get pods`
- `kubectl -n <nameSpace> describe pods <podName>`
- deploy additional scheduler: copy default /etc/kubernetes/manifests scheduler pod definition file. make these modifications: `leader-elect=false` and `--scheduler-name=<name>`; metadata: name: update the name| name of the container: update; kubectl create -f file.yaml.

### configure scheduler

kube adm:

![34](./assets/034.PNG)

additional schedulers

![35](./assets/035.PNG)

- <https://github.com/kubernetes/community/blob/master/contributors/devel/>
- <https://github.com/kubernetes/community/blob/master/contributors/devel/sig-scheduling/scheduler.md>
- <https://kubernetes.io/blog/2017/03/advanced-scheduling-in-kubernetes>
- <https://jvns.ca/blog/2017/07/27/how-does-the-kubernetes-scheduler-work/>
- <https://stackoverflow.com/questions/28857993/how-does-kubernetes-scheduler-work>

## logging and monitoring

resource consumption - what to monitor?

- metrics server - one metrics server per k8s cluster. it retrieves metrics from each of the k8s nodes and pods, aggregates them and stores them in memory (this service is an in-memory solution). it does not store information on the disk, you cannot see historical performance data. we need advanced monitoring soultion. the kubelect runs a subcomponent known as cAdvisor (container Advisor) responsible for retrieving performance metrics from PODs and exposing them through the kubelet api to make the metrics available for the metrics server . running minikube - `minikube addons enable metrics-server` - for all other environments, run `git clone https://github.com/kubernetes-incubator/metrics-serve` + `kubectl create -f deploy/1.8+/`; these commands deploys a number of pods, services and roles to allow the metrics server to pull the necessary data - to see data: `kubectl top node` `kubectl top pod`. kodekloud component: <https://github.com/kodekloudhub/kubernetes-metrics-server.git>
- prometheus and other monitoring apps

### application logs

logging in docker: `docker run -d kodekloud/event-simulator` throw output to stdout. `docker logs -f ecf`

in k8s

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: event-simulator-pod
spec:
  containers:
  - name: event-simulator
    image: kodekloud/event-simulator
  - name: image-processor
    image: some-image-processor
```

`kubectl logs -f event-simulator-pod event-simulator` --> these logs are specific to the container running inside the pod; `kubectl logs -f <podName> <containerName>`

- `kubectl logs <podName> | grep -i whatever`

## Application Lifecycle Management

### rolling updates and rollbacks

when you first create a deployiment, it triggers a rollout - a new rollout creates a new deployment revision (revision 1). in the future, when the app is updated, a new rollout is triggered and a new deployment revision is created (revision 2).

- `kubectl rollout status <deploymentName>` see the status of the rollout
- `kubectl rollout history <deploymentName>` revisions and history of the deployment

2 types of deplyment rollout strategies

1. Recreate: destroy current pods at once and create new ones with the new version. not the default
2. rolling-update: we do not destroy all pods at once, but rather we take one pod down and bring another back up - the app doesn't go down, upgrade is seamless. if we don't specify a specific strategy, k8s will assume it's a rolling update.

say we have a definition file with a deployment; we want to update the image, we simply update the def file and run `kubectl apply -f <defFile>`

![36](./assets/036.PNG)

we can specify the image with the command: `kubectl set image <deploymentName> nginx=nginx:1.9.1` but that will not update the definition file

when a new deployment is created, say with 5 replicas, it first creates a replica set automatically, which in turn creates the number of pod required to meet the number of replicas. when we update the application, the k8s deployment object creates a new replica set under the hood and starts deploying the containers there - at the same time, taking down the pod in the old replica set following a rolling update strategy - this is what we see when we issue the `kubectl get replicasets` command.

to bring back the previous version of the app, we can issue the `kubectl rollout undo <deploymentName>`. k8s will destroy the new pods in the replica set and bring back the old replica set

```sh
for i in {1..35}; do
   kubectl exec --namespace=kube-public curl -- sh -c 'test=`wget -qO- -T 2  http://webapp-service.default.svc.cluster.local:8080/info 2>&1` && echo "$test OK" || echo "Failed"';
   echo ""
done
```

### commands and arguments in definition files - docker

a container lives as long as the process inside it is alive. if a process crashes the container dies. who defines what processes should be running on the container? on a docker image/file there is a line `CMD ["nginx"]`

on a docker file, if we have the **CMD** option, when the container is built, that command gets executed; it is "hardcoded" what it does (correr un comando por defecto que es facilmente pisable - comando que se ejecuta cuando corre el contenedor, levantar servicios o servidores que se quedan corriendo). we can use **ENTRYPOINT** on the docker file and when we run the docker image, we need to specify a parameter that will be used when running the docker image (está pensado para que no pueda ser fácilmente sobreescribible - pensado para usar el contenedor como si fuera un ejecutable).

both CMD and ENTRYPOINT can be used; cmd would be the default parameter to be used in case no parameters are passed

in k8s pods

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-sleeper-pod
spec:
  containers:
  - name: ubuntu-sleeper-pod
    image: ubuntu-sleeper-pod
    command: ["sleep2.0"] # overwrites ENTRYPOINT in docker file
    args: ["10"] # anything that is appended to the docker run command will go into this section
```

the args option in the pod def file overwrites the CMD instruction in the docker file. to overwrite the ENTRYPOINT (ep) we use the command field

![37](./assets/037.PNG)

it is not the command field that overwrites the CMD instruction in the docker file.

### environment variables

```yaml
spec:
  containers:
  - name: simple-web-app
    image: simple-web-app
  # plain key value pair
  env:
  - name: APP_COLOR
    value: pink
  # configMap
  env:
  - name: APP_COLOR
    valueFrom:
      configMapKeyRef:
  # Secrets
  env:
  - name: APP_COLOR
    valueFrom:
      secretKeyRef:
```

`docker run -e APP_COLOR=pink simple-web-app`

env is a yaml array

when you have a lot of pod def files, it will become difficult to manage environment data stored within the query files. we can take this information outside the pod definition file and manage it centrally using configuration maps.

configMaps are used to pass configuration data in the form of key-value pairs in k8s. when a pod is created, inject the configMap into the pod so the key value pair are available for the application hosted inside the container in the pod.

there are 2 phases in configuring configMaps.

1. create the config map
2. inject them into the pod

creating a config map:

- imperative way

`kubectl create configmap <config-name> --from-literal=<key>=<value>`; example: `kubectl create configmap app-config --from-literal=APP_COLOR=blue --from-literal=APP_MOD=prod`

using a file: `kubectl create configmap <config-name> --from-file=<path-to-file>`

- declarative way

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data: # rather than spec
  APP_COLOR: blue
  APP_MODE: prod
```

`kubectl create -f <file>`

```yaml
#app-config
APP_COLOR: blue
APP_MODE: prod
#mysql-config
port: 3306
max_allowrd_packet: 128M
#redis-config
port: 6379
rdb-compression: yes
```

names will be used to associate them with pods.

`kubectl get configmaps`; `kubectl describe configmaps`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-sleeper-pod
spec:
  containers:
  - name: ubuntu-sleeper-pod
    image: ubuntu-sleeper-pod
    envFrom:
    - configMapRef:
        name: app-config
```

envFrom is a list.

![38](./assets/038.PNG)

### secrets

secrets are used to store sensitve information like passwords or keys; they are similar to config maps except they are stored in a hash or enconded format.

1. create the secret
2. inject the secret in the pod

imperative:

`kubectl create secret generic <secretName> --from-literal=<key>=<value>`; `kubectl create secret generic <secretName> --from-file=<file>`

declarative

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
data:
  DB_Host: mysql
  DB_User: root
  DB_Password: paswrd
```

while creating a secret with the declarative approach we must specify the secret values in a hash format. to turn text into hash format in a linux host: `echo -n '<text>' | base64`

view the values of the secrets: `kubectl get secret <secretName> -o yaml`

decoding hash values: `echo -n '<hashedValue>' | base64 --decode`

injecting the secret:

```yaml
spec:
  containerse:
  - name: simple
    image: wharever
    envFrom:
    - secretRef:
        name: app-secret # name of the secret
```

![39](./assets/039.PNG)

![40](./assets/040.PNG)

- <https://kubernetes.io/docs/concepts/configuration/secret>
- <https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/>
- <https://kubernetes.io/docs/concepts/configuration/secret/#risks>
- <https://www.vaultproject.io/>
