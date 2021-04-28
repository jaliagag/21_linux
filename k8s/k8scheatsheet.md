# kubernetes cheatsheet

## get information

- `kubectl get pod`
- `kubectl get pods --all-namespaces`
- `kubectl describe pod <name> | grep -i image`
- `kubectl describe pod <name> | grep -i node`
- `kubectl get pods -o wide`

## manage resources

- create single pod: `kubectl run nginx --image=nginx`
- delete pod: `kubectl delete pod webapp`
- create yml from command: `kubectl run redis --image=redis123 --dry-run=client -o yml > <fileName>`
- Update a single-container pod's image version (tag) to v4: `kubectl get pod mypod -o yaml | sed 's/\(image: myimage\):.*$/\1:v4/' | kubectl replace -f -`
