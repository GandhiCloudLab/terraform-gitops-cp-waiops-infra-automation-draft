#!/usr/bin/env bash

GIT_REPO=$(cat git_repo)
GIT_TOKEN=$(cat git_token)

export KUBECONFIG=$(cat .kubeconfig)
NAMESPACE=$(cat .namespace)
COMPONENT_NAME=$(jq -r '.name // "gitops_cp_waiops"' gitops-output.json)
BRANCH=$(jq -r '.branch // "main"' gitops-output.json)
SERVER_NAME=$(jq -r '.server_name // "default"' gitops-output.json)
LAYER=$(jq -r '.layer_dir // "2-services"' gitops-output.json)
TYPE=$(jq -r '.type // "base"' gitops-output.json)

mkdir -p .testrepo

git clone https://${GIT_TOKEN}@${GIT_REPO} .testrepo

cd .testrepo || exit 1

find . -name "*"

## Verify ArgoCD
echo "-----------------------------------"
echo " 1. Verify ArgoCD"
echo "-----------------------------------"

if [[ ! -f "argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml" ]]; then
  echo "ArgoCD config missing - argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"
  exit 1
fi

echo "Printing argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"
cat "argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"

# if [[ ! -f "payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/values.yaml" ]]; then
#   echo "Application values not found - payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/values.yaml"
#   exit 1
# fi

# echo "Printing payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/values.yaml"
# cat "payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/values.yaml"

## Verify WAIOps Namespace
echo "-----------------------------------"
echo " 2. Verify WAIOps Namespace"
echo "-----------------------------------"

count=0
until kubectl get namespace "${NAMESPACE}" 1> /dev/null 2> /dev/null || [[ $count -eq 20 ]]; do
  echo "Waiting for namespace: ${NAMESPACE}"
  count=$((count + 1))
  sleep 15
done

if [[ $count -eq 20 ]]; then
  echo "Timed out waiting for namespace: ${NAMESPACE}"
  exit 1
else
  echo "Found namespace: ${NAMESPACE}. Sleeping for 30 seconds to wait for everything to settle down"
  sleep 30
fi

## Verify Pods Count in WAIOps Namespace
echo "-----------------------------------"
echo " 3. Verify Pods Count in WAIOps Namespace"
echo "-----------------------------------"
POD_COUNT=0
MIN_POD_COUNT=130
MAX_WAIT_MINUTES=120
count=0
until [[ $POD_COUNT -gt $MIN_POD_COUNT ]] || [[ $count -gt $MAX_WAIT_MINUTES ]]; do
  POD_COUNT=$(kubectl get pods -n $NAMESPACE | wc -l ) 
  echo "WAIOps Pod Count in $count minutes : $POD_COUNT"
  count=$((count + 1))
  sleep 60
done

if [[ $POD_COUNT -gt $MIN_POD_COUNT ]]; then
    echo "WAIOps Namespace Pods counts are OK and it is more than $MIN_POD_COUNT"; 
else
  echo "Timed out waiting for PODs in ${NAMESPACE}"
  echo "Only $POD_COUNT pods are created in WAIOps namespace. It should be more than  $MIN_POD_COUNT"; 
  exit 1
fi


## Verify Pods Status in WAIOps Namespace
echo "-----------------------------------"
echo " 4. Verify Pods Status in WAIOps Namespace"
echo "-----------------------------------"
VAR_RESULT=$(oc get pods -n $NAMESPACE | grep -v "Completed" | grep "0/") 
if [[ "$VAR_RESULT" != "" ]]; then 
    echo "The below pods are not runing properly in WAIOps namespace."; 
    echo " "
    echo "$VAR_RESULT"; 
    exit 1
else
    echo "WAIOps Namespace Pods status are OK"; 
fi

cd ..
rm -rf .testrepo
