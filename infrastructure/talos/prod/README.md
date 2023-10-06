# Cluster 1 Bootstrap (PROD CLUSTER)

## Talos

### Create Talos Secrets

```
talhelper gensecret > talsecret.sops.yaml
sops -e -i talsecret.sops.yaml
talhelper genconfig
export TALOSCONFIG=~/k8s-gitops/talos/clusterconfig/talosconfig
```

```
talosctl -n 172.16.13.11 apply-config --file clusterconfig/prod-m0*.yaml --insecure
talosctl -n 172.16.13.12 apply-config --file clusterconfig/prod-m1*.yaml --insecure
talosctl -n 172.16.13.13 apply-config --file clusterconfig/prod-m2*.yaml --insecure
talosctl -n 172.16.13.14 apply-config --file clusterconfig/prod-w0*.yaml --insecure
talosctl -n 172.16.13.15 apply-config --file clusterconfig/prod-w1*.yaml --insecure
talosctl -n 172.16.13.16 apply-config --file clusterconfig/prod-w2*.yaml --insecure

```


### Post Talos Setup

```
kubectl kustomize --enable-helm ./cni | kubectl apply -f -
kubectl kustomize --enable-helm ./kubelet-csr-approver | kubectl apply -f -
```