terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  # backend "s3" {
  # }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# module "remotestate" {
#   source = "../remotestate"

#   aws_region = var.aws_region
#   key = var.key
#   dynamodb_table_name = var.dynamodb_table_name
#   dynamodb_policy = var.dynamodb_policy
#   bucket_name = var.bucket_name
#   bucket_policy = var.bucket_policy
#   iamrole = var.iamrole
# }

data "cloudflare_accounts" "accounts" {}

data "cloudflare_zone" "virtual_lab" {
  name = var.zone_name
}

resource "cloudflare_zone_dnssec" "virtual_lab" {
  zone_id = data.cloudflare_zone.virtual_lab.id
}

resource "cloudflare_record" "control_node_1_A" {
  zone_id = data.cloudflare_zone.virtual_lab.id
  name = var.control_node_1_fqdn
  type = var.type_A
  ttl = var.ttl
  value = var.control_node_1_ip
}

resource "cloudflare_record" "control_node_2_A" {
  zone_id = data.cloudflare_zone.virtual_lab.id
  name = var.control_node_2_fqdn
  type = var.type_A
  ttl = var.ttl
  value = var.control_node_2_ip
}

# resource "cloudflare_record" "control_node_CNAME" {
#   zone_id = cloudflare_zone.virtual_lab.zone_id
#   name = var.control_node_hostname
#   type = var.type_CNAME
#   ttl = var.ttl
#   value = var.control_node_fqdn
# }

resource "cloudflare_record" "worker_node_1_A" {
  zone_id = data.cloudflare_zone.virtual_lab.id
  name = var.worker_node_1_fqdn
  type = var.type_A
  ttl = var.ttl
  value = var.worker_node_1_ip
}

# resource "cloudflare_record" "worker_node_1_CNAME" {
#   zone_id = cloudflare_zone.virtual_lab.zone_id
#   name = var.worker_node_1_hostname
#   type = var.type_CNAME
#   ttl = var.ttl
#   value = var.worker_node_1_fqdn
# }

resource "cloudflare_record" "worker_node_2_A" {
  zone_id = data.cloudflare_zone.virtual_lab.id
  name = var.worker_node_2_fqdn
  type = var.type_A
  ttl = var.ttl
  value = var.worker_node_2_ip
}

resource "cloudflare_record" "wildcard_virtual-lab_A" {
  zone_id = data.cloudflare_zone.virtual_lab.id
  name = var.wildcard_virtual-lab_fqdn
  type = var.type_A
  ttl = var.ttl
  value = var.control_node_1_ip
}

# resource "cloudflare_record" "worker_node_2_CNAME" {
#   zone_id = cloudflare_zone.virtual_lab.zone_id
#   name = var.worker_node_2_hostname
#   type = var.type_CNAME
#   ttl = var.ttl
#   value = var.worker_node_2_fqdn
# }