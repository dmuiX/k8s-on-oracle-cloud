variable "aws_region" {
  type = string
}
# variable "bucket_name" {
#   type = string
# }

variable "control_node_1_fqdn" {
  type = string
}

# variable "control_node_hostname" {
#   type = string
# }

variable "control_node_1_ip" {
  type = string
}

variable "control_node_2_fqdn" {
  type = string
}

variable "control_node_2_ip" {
  type = string
}

variable "ttl" {
  type = string
  default = "60"
}

variable "type_A" {
  type = string
  default = "A"
}

variable "type_CNAME" {
  type = string
  default = "CNAME"
}

variable "worker_node_1_fqdn" {
  type = string
}

# variable "worker_node_1_hostname" {
#   type = string
# }

variable "worker_node_1_ip" {
  type = string
}

variable "worker_node_2_fqdn" {
  type = string
}

# variable "worker_node_2_hostname" {
#   type = string
# }

variable "worker_node_2_ip" {
  type = string
}

variable "wildcard_virtual-lab_fqdn" {
  type = string
}

variable "zone_name" {
  type = string
}

variable "cloudflare_api_token" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "bucket_policy" {
  type = string
}

variable "iamrole" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "dynamodb_policy" {
  type = string  
}

variable "key" {
  type = string
}