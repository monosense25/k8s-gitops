# Cluster 0 Bootstrap (INFRA CLUSTER)

## Talos

### Create Talos Secrets

```
talhelper gensecret > talsecret.sops.yaml
sops -e -i talsecret.sops.yaml
talhelper genconfig
export TALOSCONFIG=~/k8s-gitops/talos/clusterconfig/talosconfig
```

```
talosctl -n 172.16.11.1 apply-config --file clusterconfig/infra-mw0*.yaml --insecure
talosctl -n 172.16.11.2 apply-config --file clusterconfig/infra-mw1*.yaml --insecure
talosctl -n 172.16.11.3 apply-config --file clusterconfig/infra-mw2*.yaml --insecure

```


### Post Talos Setup

```
kubectl kustomize --enable-helm ./cni | kubectl apply -f -
kubectl kustomize --enable-helm ./kubelet-csr-approver | kubectl apply -f -
```