# creating a HA environment

<https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/_print/#pg-015edbc7cc688d31b1d1edce7c186135>

requirements

1. 3 machines for control plane nodes
2. 3 machines for worker nodes
3. **kubeadm** and **kubelet** installed on all machines. **kubectl** is optional
4. 3 machines for etcd members

## steps

1. create a load balancer for kube-apiserver (regularly configured in the cloud)
   1. address of the load balancer must match the address of kubeadm's `ControlPlaneEndpoint`
   2. add control-plane machines to the lb control group
   3. test the connection `nc -v LOAD_BALANCER_IP PORT`
2. first control plane node
   1. `sudo kubeadm init --control-plane-endpoint "LOAD_BALANCER_DNS:LOAD_BALANCER_PORT" --upload-certs` - when `--upload-certs` is used with `kubeadm init`, the certificates of the primary control plane are encrypted and uploaded in the `kubeadm-certs` Secrets
   2. apply CNI plugin of your choice (<https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network>) - `kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"`
   3. for the rest of control plain nodes, we should use the kubeadm init output on the first node (kubeadm join)
3. external etcd nodes <https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/_print/#set-up-the-etcd-cluster>
   1. set up etcd cluster <https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/>
   2. setup SSH <https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/_print/#manual-certs>

