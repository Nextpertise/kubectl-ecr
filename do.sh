#!/bin/bash

region=$1
accountid=$2

password=$(aws ecr get-login --no-include-email --region eu-central-1 --registry-ids ${accountid} | awk '{print $6}')
secret=$(echo '{"auths":{"_ACCOUNTID_.dkr.ecr._REGION_.amazonaws.com":{"password":"_PASSWORD_","username":"AWS"}}}' | sed "s/_REGION_/${region}/g" | sed "s/_ACCOUNTID_/${accountid}/g" | sed "s/_PASSWORD_/${password}/g" | base64)

namespaces=$(kubectl get namespaces -o json | jq -r .items[].metadata.name)
for namespace in ${namespaces}; do
  cat registry.yaml | sed "s/_NAME_/ecr-${region}/g" | sed "s/_SECRET_/${secret}/g" | sed "s/_NAMESPACE_/${namespace}/g" > generated.yaml
  kubectl apply -f generated.yaml
done
