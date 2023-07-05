provider "oci" {
  region = var.region
}

resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_id
  cidr_blocks    = [var.vcn_cidr_block]
}

resource "oci_core_subnet" "public_subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.vcn.id
  cidr_block        = var.cidr_block_public
  security_list_ids = [ oci_core_security_list.public_subnet_sl.id ]
}

resource "oci_core_security_list" "public_subnet_sl" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id

  # allow all outgoing traffic
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  #allow incoming traffic from the public_subnet
  ingress_security_rules {
    source = "10.0.0.0/16"
    protocol    = "all"
  }

  # allow incoming traffic from port 6443
  ingress_security_rules {
    source = "0.0.0.0/0"
    protocol    = "6"
    tcp_options {
      min = 6443
      max = 6443
    }
  }
}

resource "oci_core_subnet" "private_subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.vcn.id
  cidr_block        = var.cidr_block_private
  security_list_ids = [ oci_core_security_list.private_subnet_sl.id ]
}

resource "oci_core_security_list" "private_subnet_sl" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id

  # allow all outgoing traffic
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  #allow incoming traffic from the public_subnet
  ingress_security_rules {
    source = "10.0.0.0/16"
    protocol    = "all"
  }
}

resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  enabled        = true
}

resource "oci_load_balancer_load_balancer" "lb" {
  compartment_id = var.compartment_id
  display_name = var.lb_name
  shape = "flexible"
  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }
  subnet_ids = [ oci_core_subnet.public_subnet.id ]
  is_private = false
}

data template_file "cloud-config-control-plane" {
  template = file("${path.module}/templates/cloud-config.yaml")
  vars = {
    install_k3s_cmd = "curl -sfL https://get.k3s.io | K3S_TOKEN=${data.token} sh -s - server --cluster-init"
  }
}

resource "oci_core_instance" "k3s_control_plane_1" {
  compartment_id = var.compartment_id
  availability_domain = var.availability_domain
  shape = var.micro_instance_config.shape_id
  metadata = {
    ssh_authorized_keys = "${file(var.ssh_public_key_file)}"
    user_data = "${base64encode(data.template_file.cloud-config-control-plane.rendered)}"
  }
  source_details {
    source_id   = var.micro_instance_config.source_id
    source_type = var.micro_instance_config.source_type
  }
  shape_config {
    memory_in_gbs = var.micro_instance_config.ram
    ocpus         = var.micro_instance_config.ocpus
  }
  create_vnic_details {
    hostname_label = var.control_plane_hostname
    subnet_id  = var.cluster_subnet_id
    private_ip = cidrhost(var.cidr_blocks[0], 10)
    nsg_ids    = [var.permit_ssh_nsg_id]
  } 
}

resource "oci_core_instance" "k3s_control_plane_2" {
  compartment_id = var.compartment_id
  availability_domain = var.availability_domain
  shape = var.micro_instance_config.shape_id
  metadata = {
    ssh_authorized_keys = "${file(var.ssh_public_key_file)}"
    user_data = "${base64encode(data.template_file.cloud-config-control-plane.rendered)}"
  }
  source_details {
    source_id   = var.micro_instance_config.source_id
    source_type = var.micro_instance_config.source_type
  }
  shape_config {
    memory_in_gbs = var.micro_instance_config.ram
    ocpus         = var.micro_instance_config.ocpus
  }
  create_vnic_details {
    hostname_label = var.control_plane_hostname
    subnet_id  = var.cluster_subnet_id
    private_ip = cidrhost(var.cidr_blocks[0], 10)
    nsg_ids    = [var.permit_ssh_nsg_id]
  }
}

data template_file "cloud-config-workers" {
  template = file("${path.module}/templates/cloud-config.yaml")
  vars = {
    install_k3s_cmd = "curl -sfL https://get.k3s.io | K3S_TOKEN=${data.token} sh -s - server --server https://${oci_core_instance.k3s_control_plane }:6443"
  }
}

resource "oci_core_instance" "k3s_worker_1" {
  compartment_id = var.compartment_id
  availability_domain = var.availability_domain
  shape = var.micro_instance_config.shape_id
  metadata = {
    ssh_authorized_keys = "${file(var.ssh_public_key_file)}"
    user_data = "${base64encode(data.template_file.cloud-config.rendered)}"
  }
  create_vnic_details = {
    hostname_label = var.worker1_hostname  
  }
  depends_on = [oci_core_instance.k3s_control_plane]
}