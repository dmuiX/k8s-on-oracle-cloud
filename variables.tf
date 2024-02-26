variable "compartment_id" {
  type        = string
  description = "The compartment to create the resources in"
}
variable "lb_name" {
  type        = string
  description = "The loadbalancer name"
}
variable "region" {
  type        = string
  description = "The region to provision the resources in"
}
variable "cidr_block_private" {
  type        = string
  description = "cidr_block for the private subnet"
}
variable "cidr_block_public" {
  type        = string
  description = "cidr_block for the public subnet"
}
variable "vcn_cidr_block" {
  type        = string
  description = "cidr_block for the vcn"
}

#variable "availability_domain" {
#  type        = string
#  description = "availability_domain in the oracle cloud"
#}

variable "ssh_authorized_keys" {
  type = string
  description = "ssh key fingerprint to access k8s nodes"
}

variable "ssh_public_key_file" {
  type = string
  description = "ssh public key to access k8s nodes"
}
variable "control_plane_hostname" {
  
}