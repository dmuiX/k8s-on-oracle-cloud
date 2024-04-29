# # Output the "list" of all availability domains.
# # output "all-availability-domains-in-your-tenancy" {
# #     value = data.oci_identity_availability_domains.ads.availability_domains
# # }

# # Outputs for compartment

output "compartment-name" {
    value = oci_identity_compartment.k8s-cluster-on-oci_compartment.name
}

output "compartment-OCID" {
    value = oci_identity_compartment.k8s-cluster-on-oci_compartment.id
}

# # output "private_subnet_id" {
# #     value = oci_core_subnet.k8s-cluster-on-oci_private_subnet.id
# # }

output "public_subnet_id" {
    value = oci_core_subnet.k8s-cluster-on-oci_public_subnet.id
}

output loadbalancer_ip_address_details {
    value = oci_load_balancer_load_balancer.k8s-cluster-on-oci_load_balancer.ip_address_details
}

output "amd_instance_public_ip" {
    value = oci_core_instance.amd_instance.public_ip
}

# output control_node_1_ip_address_details {
#     value = oci_core_instance.control_node_1.public_ip
# }

# output control_node_2_ip_address_details {
#     value = oci_core_instance.control_node_2.public_ip
# }

# # bastion host
# # output private_endpoint_ip_address {
# #     value = oci_bastion_bastion.k8s-cluster-on-oci_bastion.private_endpoint_ip_address
# # }
