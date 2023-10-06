#!/usr/bin/env bash

# Deploy the configuration to the nodes
talosctl apply-config -n prod-m0.monosense.io -f ./clusterconfig/cluster-1-prod-m0.monosense.io.yaml --insecure
talosctl apply-config -n prod-m1.monosense.io -f ./clusterconfig/cluster-1-prod-m1.monosense.io.yaml --insecure
talosctl apply-config -n prod-m2.monosense.io -f ./clusterconfig/cluster-1-prod-m2.monosense.io.yaml --insecure
talosctl apply-config -n prod-w0.monosense.io -f ./clusterconfig/cluster-1-prod-w0.monosense.io.yaml --insecure
talosctl apply-config -n prod-w1.monosense.io -f ./clusterconfig/cluster-1-prod-w1.monosense.io.yaml --insecure
talosctl apply-config -n prod-w2.monosense.io -f ./clusterconfig/cluster-1-prod-w2.monosense.io.yaml --insecure