# kubernetes cheatsheet

## get information

- `kubectl get pod`
- `kubectl get pods --all-namespaces || -A`
- `kubectl describe pods <name> | grep -i image`
- `kubectl describe pods <name> | grep -i node`
- `kubectl describe daemonsests --namespace=<nsName>`
- to escale the number of replicas, we can simply update the rs config file `kubectl replace -f <file>`; to do this task manually, we can run `kubectl scale --replicas=6 <file>` or `kubectl scale --replicas=6 <type> <rsName>`<-- this does not update the rs definition file. We can also use `kubectl edit <replicasetName>`, update the configuration there and then delte de pods
- `kubectl get pods -o wide`
- `watch "kubectl get pods"`
- view containers within a pod: `kubectl logs webapp -c`

## manage resources

- create single pod: `kubectl run nginx --image=nginx`
- delete pod: `kubectl delete pod webapp`
- create yml from command: `kubectl run redis --image=redis123 --dry-run=client -o yml > <fileName>`
- Update a single-container pod's image version (tag) to v4: `kubectl get pod mypod -o yaml | sed 's/\(image: myimage\):.*$/\1:v4/' | kubectl replace -f -`
- `kubectl drain <nodeName>` also cordons it
- `kubectl uncordon <nodeName>` gets the back into the pool to receive pods
- run ad hoc command on container: `kubectl exec -it ubuntu-sleeper -- date -s '19 APR 2012 11:14:00'`
- switch to anothe ns: `kubectl config set-context $(kubectl config current-context) --namespace=dev`

## create docs

- `kubectl get pod webapp -o yaml > my-new-pod.yaml` extract the pod definition i nyaml

## rollout - deployments

- create `kubectl create -f <yamlfile>.yaml`
- get `kubectl get deployments`
- update `kubectl apply -f <yamlFile>.yaml` || `kubectl set image <depplyName> <contName-nginx>=<newImage-nginx:1.9.1`
- status: `kubectl rollout status deployments <deploymentName>` || `kubectl rollout history deployments <deploymentName>`
- rollback: `kubectl rollout undo deployments <deploymentName>`

## upgrade k8s version

## certificates

- to check the information on a .crt file: `openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout`

## secrets

- `kubectl create secret docker-registry private-reg-cred --docker-username=dock_user --docker-password=dock_password --docker-server=myprivateregistry.com:5000 --docker-email=dock_user@myprivateregistry.com`

## ports

| service/controller | port |
|------ |------|
| kube-api | 6443 |
| etcd | 2379 |

## etcdctl

- `etcdctl get` : get keyts stored
