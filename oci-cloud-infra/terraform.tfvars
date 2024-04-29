### OCI STUFF ###
tenancy_ocid = ""
user_ocid = ""
fingerprint = ""
region = "eu-frankfurt-1"
compartment_name = "k8s-cluster-on-oci"
email = "admin@adminnnnns.com"

### VAULT ###

### NETWORKING ###
loadbalancer = "k8s-cluster-on-oci_load_balancer"
loadbalancer_shape = "10Mbps-Micro"
public_subnet_cidr = "10.0.0.0/24"
# private_subnet_cidr = "192.168.66.0/24"

### COMPUTING INSTANCES ###

arm_shape = "VM.Standard.A1.Flex"
amd_shape = "VM.Standard.E2.1.Micro"
platform_image = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa6rml6o6ahr6466gf623erbzg6zjrnabxtbweb3ihuenpxcz65ima" #"Oracle-Linux-9.3-aarch64-2024.03.25-0"
ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICW36PfNNkMOmj0Ph9W92Ni7DRTmWn0cjxk7mM/GEr84"
memory_in_gbs = 1
ocpus = 1
boot_volume_size_in_gbs = 50
availability_domain_1 = "wXwm:EU-FRANKFURT-1-AD-1"
control_node_1_fqdn = "control_node_1"
control_node_1_ip = "192.168.66.11"
availability_domain_2 = "wXwm:EU-FRANKFURT-1-AD-2"
control_node_2_fqdn = "control_node_2"
control_node_2_ip = "192.168.66.12"
