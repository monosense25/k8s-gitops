# Cluster 0 Bootstrap

## Talos

### Create Talos Secrets

```
talhelper gensecret > talsecret.sops.yaml
sops -e -i talsecret.sops.yaml
talhelper genconfig
export TALOSCONFIG=~/k8s-gitops/talos/clusterconfig/talosconfig
```

```
talosctl -n 10.0.0.10 apply-config --file clusterconfig/k8s-m0*.yaml --insecure
talosctl -n 10.0.0.11 apply-config --file clusterconfig/k8s-m1*.yaml --insecure
talosctl -n 10.0.0.12 apply-config --file clusterconfig/k8s-m2*.yaml --insecure

```


### Post Talos Setup

```
kubectl kustomize --enable-helm ./cni | kubectl apply -f -
kubectl kustomize --enable-helm ./kubelet-csr-approver | kubectl apply -f -
```