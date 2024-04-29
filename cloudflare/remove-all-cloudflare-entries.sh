#!/bin/bash

#!!!
# permission needed: #zone:edit
#!!!

read -s -p "cloudflare api-token: " TOKEN
DOMAIN="virtual-lab.pro"

ZONE_ID=$(curl -s -H "Authorization: Bearer $TOKEN"      -H "Content-Type:application/json" -X GET "https://api.cloudflare.com/client/v4/zones?name=$DOMAIN"| jq -r '.result[] | {id} | .id') 

curl -s -X GET https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?per_page=500 \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" | jq .result[].id |  tr -d '"' | (
  while read id; do
    curl -s -X DELETE https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${id} \
      -H "Authorization: Bearer ${TOKEN}" \
      -H "Content-Type: application/json"
  done
  )