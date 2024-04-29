# k8s-on-oracle-clou

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

Networking is changed now to public subnet and all instances as public instances only.

linux distri with a very current kernel necessary, maybe fedora

### Install terraform oci on mac

https://gist.github.com/olegstepura/e18098bf1367f86f2bb2b7dbbc49b6f9

### deployment of dns entries either via cloudflare or if its easier via oci

delete all dns entries:
use the script provided in cloudflare
https://gist.github.com/slayer/442fa2fffed57f8409e0b23bd0673a92

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

## execute plan

### configure oci provider

https://library.tf/providers/oracle/oci/latest/docs/resources/core_cpe

```bash
export TF_VAR_private_key=`openssl rsa -in private.key -check` 
tofu init
tofu plan
tofu apply
```
### A Compartment seems necessary

Seems to be like a container for aa whole infrastructure inside my oci account
https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-compartment/01-summary.htm#

### IAM Policies

https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/accesscontrol.htm#Policies
https://docs.oracle.com/en-us/iaas/Content/Identity/Concepts/commonpolicies.htm

actually its a bit more complicated:

to make a loadbalancer policy run a tenancy is needed. 
"Allow group ${oci_identity_group.k8s-cluster-on-oci_admins.name} to manage load-balancers in tenancy"

for user, groug and policy tenancy is necessary `compartment_id = var.tenancy_ocid`

vault type must be vault_type = "DEFAULT"

### Free Tier

https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm#compute

#### Computing

2 VM.Standard.E2.1.Micro 
4 OCPU and 24GB VM.Standard.A1.Flex

the arm instances are not available so it makes no sense..

#### Images

https://docs.oracle.com/en-us/iaas/images/

For now I will use:
Oracle-Linux-9.3-aarch64-2024.03.25-0
has kernel 5.15

Maybe I will switch to ubuntu:
Canonical-Ubuntu-22.04-aarch64-2024.02.18-0
has also kernel 5.15 but might be upgradable to 6.2!
When it is published I will use:
Canonical-Ubuntu-24.04

#### Storage

200 GB of Block Volume.
five volume backups.
50 GB boot volume for storage per instance
20 GB of Always Free Overview of Object Storage.

#### Vault

All master encryption keys protected by software are free. All tenancies get 20 key versions of master encryption keys protected by a hardware security module (HSM) and 150 Always Free Vault secrets. 

#### DB

2 Oracle Autonomous Databases. 
1 Oracle NoSQL Database with up to 133 million reads per month, 133 million writes per month, and 3 tables with 25 GB storage per table.

#### Networking

1 Flexible Load Balancer Min and Max 10 Mbps.
1 Network Load Balancer.
2 VCN.

#### Bastion Host

Free
OCI's Bastion service provides restricted and time-limited Secure Shell Protocol (SSH) access to target resources that don't have public endpoints.

### Availability Domain

https://gmusumeci.medium.com/how-to-get-the-list-of-oracle-cloud-infrastructure-oci-availability-domains-ad-525434dfbfa1

```bash
    {
      "compartment-id": "ocid1.tenancy.oc1..aaaaaaaav75hekijieedwtzyf3e3kvelgbodmdwn3gyj44doyhhezpsdkira",
      "id": "ocid1.availabilitydomain.oc1..aaaaaaaaiifj24st3w4j7cowuo3pmqcuqwjapjv435vtjmgh5j7q3flguwna",
      "name": "wXwm:EU-FRANKFURT-1-AD-1"
    },
    {
      "compartment-id": "ocid1.tenancy.oc1..aaaaaaaav75hekijieedwtzyf3e3kvelgbodmdwn3gyj44doyhhezpsdkira",
      "id": "ocid1.availabilitydomain.oc1..aaaaaaaaa2artt5wizbqvwl3rgptylx2l7jqbnyv4dygcfvlrd3dphvi3mdq",
      "name": "wXwm:EU-FRANKFURT-1-AD-2"
    },
    {
      "compartment-id": "ocid1.tenancy.oc1..aaaaaaaav75hekijieedwtzyf3e3kvelgbodmdwn3gyj44doyhhezpsdkira",
      "id": "ocid1.availabilitydomain.oc1..aaaaaaaalcdcbl7u6akbmkojxhrozpj2v7yavqqydkj3ytyjbt47lnoqnm2q",
      "name": "wXwm:EU-FRANKFURT-1-AD-3"
    }
```
### Computing

#### No Computing Cluster!
https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/compute-clusters.htm

#### Problems with arm instances

seems like the free arm instances are very rare. so terraform is throwing “Out of Capacity” issue. Well Project is on Hold for now. As this does not make sense.

### Networking

#### Site2Site VPN

https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/overviewIPsec.htm#top

#### Public IPs
https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingpublicIPs.htm

NAT-Gateway and Public Load Balancer always get Public IPs.
Load-Balancer: regional reserved public IP => IP can be chosen or regional ephemeral public IP => Not changeable
NAT-Gateway: regional ephemeral public IP => Not changeable

#### Loadbalancer

https://docs.oracle.com/en-us/iaas/Content/GSG/Tasks/loadbalancing.htm

Empty Security List
Route Table with 

Target Type: Select Internet Gateway.
Target: Select your VCN's internet gateway.
Destination CIDR Block: Enter 0.0.0.0/0.

#### Nat-Gateway

https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/NATgateway.htm

Route Table with:

Target Type: NAT Gateway.
Target NAT Gateway: The NAT gateway.
Destination CIDR Block: 0.0.0.0/0

#### DNS

https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/dns.htm
