# k8s-on-oracle-cloud

This repo contains a complete deployment of a working k8s cluster on the oracle cloud just using free tier components. Everything is done via IAC so no manual deployment necessary.

non exhaustive list of features:

- vms and network infra deployment via OpenTofu
- k8s-Cluster Deployment via Ansible
- hostnames and dns-names for applications via external-dns using cloudflare
- letsencryt certificates via traefik
- ingress controller is traefik
- networking cni is cilium
- secrets-management via external-secrets on oci secrets manager
- deployment of applications and k8s-components via argocd

oci = oracle cloud infrastructure

## Plan

### creation of the infrastructure via terraform/opentofu

![cloud-infra](https://github.com/dmuiX/k8s-on-oracle-cloud/blob/main/cloud-infra.png)

linux distri with a very current kernel necessary, maybe edora

### deployment of dns entries either via cloudflare or if its easier via oci

domain: virtual-lab.org

hostnames/dns entries:
control-node1.
control-node2.
worker1.
worker2.
argocd.

### create k8s cluster via ansible

using [k8s the hard way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
as a tutorial
and then create ansible playbooks out of it

### use argocd to deploy the necessary components for k8s

- cilium as cni and to replace kube-proxy (very current kernel necessary): https://docs.cilium.io/en/stable/network/kubernetes/kubeproxy-free/
- external-secrets using oci secrets manager
- external-dns using cloudflare
- traefik as ingress controller and as a letsencryt cert-solver via http01: https://medium.com/kubernetes-tutorials/deploying-traefik-as-ingress-controller-for-your-kubernetes-cluster-b03a0672ae0c

credits:

Actually the idea for this specific infrastructure came from here: 
https://medium.com/geekculture/how-to-create-an-always-free-k8s-cluster-in-oracle-cloud-60be3b107c44
and of course the great kubernetes-the-hard-way
repo: 
https://github.com/kelseyhightower/kubernetes-the-hard-way
