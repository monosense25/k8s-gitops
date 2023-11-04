#!/usr/bin/env bash

# Deploy the configuration to the nodes
talosctl apply-config -n 172.16.11.10 -f ./clusterconfig/cluster-0-k8s-m0.monosense.io.yaml --insecure
talosctl apply-config -n 172.16.11.11 -f ./clusterconfig/cluster-0-k8s-m1.monosense.io.yaml --insecure
talosctl apply-config -n 172.16.11.12 -f ./clusterconfig/cluster-0-k8s-m2.monosense.io.yaml --insecure
talosctl apply-config -n 172.16.11.13 -f ./clusterconfig/cluster-0-k8s-w0.monosense.io.yaml --insecure
talosctl apply-config -n 172.16.11.14 -f ./clusterconfig/cluster-0-k8s-w1.monosense.io.yaml --insecure
talosctl apply-config -n 172.16.11.15 -f ./clusterconfig/cluster-0-k8s-w2.monosense.io.yaml --insecure
talosctl apply-config -n 172.16.11.16 -f ./clusterconfig/cluster-0-k8s-w3.monosense.io.yaml --insecure