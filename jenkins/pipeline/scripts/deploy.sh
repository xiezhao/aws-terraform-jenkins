#!/usr/bin/env bash
set -euo pipefail

namespace=demo
service=demo-active
image="025066243171.dkr.ecr.ap-southeast-1.amazonaws.com/demo-service:${IMAGE_VERSION}"

service_json=$(kubectl -n "$namespace" get service "$service" -o json)
phase=$(jq -r '.metadata.annotations.phase // empty' <<< "$service_json")
active=$(jq -r '.spec.selector.color // empty' <<< "$service_json")

if [[ "$phase" != release ]]; then
  echo "the service is not in release"
  exit 1
fi

if [[ "$active" == blue ]]; then
  inactive=green
else
  inactive=blue
fi

deployment="demo-$inactive"
replicas=$(kubectl -n "$namespace" get deployment "demo-$active" -o jsonpath='{.spec.replicas}')

kubectl -n "$namespace" annotate service "$service" phase=deploying --overwrite
kubectl -n "$namespace" set image "deployment/$deployment" "app=$image"
kubectl -n "$namespace" scale deployment "$deployment" --replicas="$replicas"
if ! kubectl -n "$namespace" rollout status "deployment/$deployment" --timeout=5m; then
  if ! kubectl -n "$namespace" scale deployment "$deployment" --replicas=0; then
    echo "Failed to scale down $deployment" >&2
  fi
  kubectl -n "$namespace" annotate service "$service" phase=release --overwrite
  exit 1
fi
kubectl -n "$namespace" patch service "$service" --type=merge -p "{\"spec\":{\"selector\":{\"color\":\"$inactive\"}}}"
