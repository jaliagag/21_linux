# k8s DXC course

<https://dxc.percipio.com/channels/88c14df0-cee2-11e7-b717-977a4c138a33>

## Bootstrapping k8s cluter with kubeadm

```console
sudo apt update -y
sudo apt install -y apt-transport-https curl
sudo curl -s <urlforGPG> | sudo apt-key add -
sudo vi /etc/apt/sources.list.d/kubernetes.list
    # deb https://apt.kubernetes.io/ kubernetes-xenial main
sudo apt update -y
sudo apt install -y kubelet kubeadm kubectl

sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl status docker
sudo systemctl enable docker
curl -s <gpgurl> | sudo apt-key add - <<---adding a key
vi /etc/apt/sources.list.d/kubernetes.list
    # deb http://apt.kubernetes.io/ kubernetes-xenial main
sudo apt update -y
sudo apt install -y kubelet kubeadm kubectl kubernetes-cni
<<<<< DISABLING SWAP >>>>>
sudo swapoff -a
sudo vi /etc/fstab
<<<<< INITIALIZING CLUSTER >>>>>
sudo kubeadm init
mkdit -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
<<<<< ON NODES >>>>>
<<<<< JOINING WORKERS >>>>>
kubeadm join --token <value> <ipaddress>:<port>
kubectl version --client
kubectl config view
<<<<< COMMUNICATION WITH DIFFERENT CLUSTERS >>>>>
kubectl config --kubeconfig=<nameOfFile> set-cluster <k8sclusterName> --server=https://<k8sIP> --certificate-authority=ca.crt
kubectl config --kubeconfig=<nameOfFile> set-cluster <k8sclusterName> --server=https://<k8sIP> --insecure-skip-tls-verify
<<<<< add user t >>>>>
kubectl config --kubeconfig=<file> set-credentials <username> --client-certificate=ca.cert --client-key=ca.key 
<<<< files need to be on the node >>>>
<<<< add context >>>>
kubectl config --kubeconfig=<file> set-context kubernetes-admin@<k8sserver> --cluster=<clustername> --namespace=<namespacename> --user=<username>
kubectl config --kubeconfig=<nameOfConfigFile> view
<<<<< SET CONTEXT >>>>>
kubectl config --kubeconfig=<file> use-context kubernetes-admin@kubernetes
```

prepare k8s master for flannel

```console
modprobe bridge
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
wget <flannelurl>
<<<<< MODIFY FLANNEL MANIFEST FILE >>>>>
vi kube-flannel.yml
```

```yml
net-conf.json:
{
    "Network": "172.31.17.67/16",
    "Backend": {
        "Type": "vxlan",
        "VNI": 4096,
        "Port": 4789
    }
}
```

```console
kubectl apply -f <flannelconfig file>
kubectl get pods -n kube-system
    # search for flannel
```

create token for worker node: `kubeadm token create --print-join-command`

### kubectl in proxy mode

```console
kubectl describe secret
<<<<< get token for default user account >>>>>
APISERVER=$(kubectl config view --minify | grep server | cut -f 2- -d ":" | tr -d " ")
SECRET_NAME=$(kubectl get secrets | grep ^default | cut -f1 -d ' ')
TOKEN=$(kubectl describe secret $SECRET_NAME | grep -E '^token' | cut -f2 -d ':' | tr -d " ")
curl $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure
```

using kubectl proxy

```console
kubectl proxy --port=8080
```

### namespaces limitrange and pods

k8s has the ability to support multiple virtual clusters, maybe on the same physical cluster - these virtual clusters are called _namespaces_. The primary objective of namespaces is to enable the use of multiple environments for many users. We use namespaces in order to provide scope for all the names we are using for resources.

```console
kubectl get namespace
kubectl create namespace <nameOfNamespace>
```

memory tune

```yml
apiVersion: v1
kind: LimitRange
metadata:
    name: mem-limit-range
spec:
    limits:
    - defaults:
        memory: 512Mi
      defaultRequest:
        memory: 256Mi
      type: Container
```

`kubectl apply -f <file>.yml --namespace=<name>`

Containers created in the name space will have that memory limit (if they don't have memory specified)

pod config

```yml
apiVersion: v1
kind: Pod
metadata:
    name: default-mem-demo
spec:
  containers:
  - name: default-mem-demo-container
    image: nginx
```

create pod: `kubectl apply -f <file>.yml --namespace=<namespace>`

`kubectl get pod default-mem-demo --output=yaml --namespace=<namespace>`

### labels and annotations

labels: key value pairs attached to objects to identify them; created via yaml or kubectl command (`kubectl run <developmentname> --image=<imagename> --replicas=<#ofreplicas> --labels="<key>=<value>, <key>=<value>"`)

label selectors:

- `kubectl get pods --show-labels`
- `kubectl label pods labelexample type=preproduction` manage daemons
- `kubectl get pods --selector type=preproduction`
- ``
