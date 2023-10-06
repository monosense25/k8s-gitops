#!/usr/bin/env bash

# Deploy the configuration to the nodes
talosctl apply-config -n infra-mw0.monosense.io -f ./clusterconfig/cluster-0-infra-mw0.monosense.io.yaml --insecure
talosctl apply-config -n infra-mw1.monosense.io -f ./clusterconfig/cluster-0-infra-mw2.monosense.io.yaml --insecure
talosctl apply-config -n infra-mw2.monosense.io -f ./clusterconfig/cluster-0-infra-mw2.monosense.io.yaml --insecure