compartment_id         = "ocid1.tenancy.oc1..aaaaaaaav75hekijieedwtzyf3e3kvelgbodmdwn3gyj44doyhhezpsdkira"
region                 = "eu-frankfurt-1"

ssh_public_key_file    = "~/.ssh/id_ecdsa.pub"

vcn_cidr_block         = "10.0.0.0/16"
cidr_block_public      = "10.0.0.0/24"
cidr_block_private     = "10.0.1.0/24"

#availability_domain    = "wXwm:EU-FRANKFURT-1-AD-1"

lb_name                = "virtual-lab-lb"

private_subnet_dns     = "private-subnet"
public_subnet_dns      = "public-subnet"
vnc_dns                = "virtual-lab"
control_plane_hostname = "k3s-control-plane"
worker1_hostname       = "k3s-worker-1"
worker2_hostname       = "k3s-worker-2"
worker3_hostname       = "k3s-worker-3"

ampere_instance_config = {
    shape_id = "VM.Standard.A1.Flex"
    ocpus    = 2
    ram      = 12
    // Canonical-Ubuntu-22.04-Minimal-aarch64-2023.05.20-00 eu-frankfurt-1
    source_id   = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaavv2mpdlhnbt6zehvubcorl4oqkrzthc5ustlfs7npfhkk7r6xyq"
    source_type = "image"
  }
micro_instance_config = {
  shape_id = "VM.Standard.E2.1.Micro"
  ocpus    = 1
  ram      = 1
  // Canonical-Ubuntu-22.04-Minimal-2023.05.20-0 eu-frankfurt-1
  source_id   = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaany47uztnfnnuj3ccxztw3bq6dma6djo3gn3uemjwplcgklgy774a"
  source_type = "image"
}