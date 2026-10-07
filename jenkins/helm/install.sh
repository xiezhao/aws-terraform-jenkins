#!/usr/bin/env bash
set -euo pipefail

EKS_CONTEXT='arn:aws:eks:ap-southeast-1:025066243171:cluster/demo-eks-dev'
chart_version=5.9.66
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
chart_path="${script_dir}/jenkins-${chart_version}.tgz"

kubectl --context "${EKS_CONTEXT}" apply -f "${script_dir}/storageclass.yaml"
kubectl --context "${EKS_CONTEXT}" create namespace jenkins --dry-run=client -o yaml \
  | kubectl --context "${EKS_CONTEXT}" apply -f -
helm upgrade --install jenkins "${chart_path}" \
  --kube-context "${EKS_CONTEXT}" \
  --namespace jenkins \
  --create-namespace \
  --values "${script_dir}/values.yaml" \
  --wait \
  --timeout 15m
