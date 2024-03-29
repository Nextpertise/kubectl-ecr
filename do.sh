#!/bin/bash

region=$1
accountid=$2

password=$(aws ecr get-login --no-include-email --region ${region} --registry-ids ${accountid} | awk '{print $6}')
echo "[$password]"
secret=$(echo -n '{"auths":{"_ACCOUNTID_.dkr.ecr._REGION_.amazonaws.com":{"password":"_PASSWORD_","username":"AWS"}}}' | sed "s/_REGION_/${region}/g" | sed "s/_ACCOUNTID_/${accountid}/g" | sed "s/_PASSWORD_/${password}/g" | base64 -w 0)

namespaces=$(kubectl get namespaces -o json | jq -r .items[].metadata.name)
for namespace in ${namespaces}; do
  echo $namespace
  if [[ "${namespace:0:2}" == "p-" ]]; then
    echo "skipping project namespace: $namespace"
    continue
  fi
  if [[ "${namespace:0:2}" == "u-" ]]; then
    echo "skipping user namespace: $namespace"
    continue
  fi
  if [[ "${namespace:0:5}" == "user-" ]]; then
    echo "skipping user namespace: $namespace"
    continue
  fi
  cat /root/registry.yaml | sed "s/_NAME_/ecr-${region}/g" | sed "s/_SECRET_/${secret}/g" | sed "s/_NAMESPACE_/${namespace}/g" > /root/generated.yaml
  kubectl apply -f /root/generated.yaml
done
