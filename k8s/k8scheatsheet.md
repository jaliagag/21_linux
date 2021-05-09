# kubernetes cheatsheet

## get information

- `kubectl get pod`
- `kubectl get pods --all-namespaces || -A`
- `kubectl describe pods <name> | grep -i image`
- `kubectl describe pods <name> | grep -i node`
- `kubectl describe daemonsests --namespace=<nsName>`
- `kubectl get pods -o wide`
- `watch "kubectl get pods"`
- view containers within a pod: `kubectl logs webapp -c`

## manage resources

- create single pod: `kubectl run nginx --image=nginx`
- delete pod: `kubectl delete pod webapp`
- create yml from command: `kubectl run redis --image=redis123 --dry-run=client -o yml > <fileName>`
- Update a single-container pod's image version (tag) to v4: `kubectl get pod mypod -o yaml | sed 's/\(image: myimage\):.*$/\1:v4/' | kubectl replace -f -`

## create docs

- `kubectl get pod webapp -o yaml > my-new-pod.yaml` extract the pod definition i nyaml

## rollout - deployments

- create `kubectl create -f <yamlfile>.yaml`
- get `kubectl get deployments`
- update `kubectl apply -f <yamlFile>.yaml` || `kubectl set image <depplyName> <contName-nginx>=<newImage-nginx:1.9.1`
- status: `kubectl rollout status deployments <deploymentName>` || `kubectl rollout history deployments <deploymentName>`
- rollback: `kubectl rollout undo deployments <deploymentName>`
