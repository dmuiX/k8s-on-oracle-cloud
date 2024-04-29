output "virtual_lab_nameservers" {
  value       = data.cloudflare_zone.virtual_lab.name_servers
  description = "The nameservers of the virtual-lab zone."
}

output "dynamodb_table_name" {
  value       = module.remotestate.dynamodb_table_name
  description = "The name of the DynamoDB table"
}

output "s3_bucket_arn" {
  value       = module.remotestate.s3_bucket_arn
  description = "The ARN of the S3 bucket"
}

output "cloudflare_zone_dnssec-virtual_lab-ds" {
  value       = cloudflare_zone_dnssec.virtual_lab.ds
  description = "ds_record"
}
