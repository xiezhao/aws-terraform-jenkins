#!/usr/bin/env bash
set -euo pipefail

namespace=demo
service=demo-active

phase=$(kubectl -n "$namespace" get service "$service" -o jsonpath='{.metadata.annotations.phase}')
if [[ "$phase" != deploying ]]; then
  echo "Service phase is $phase; no pending release" >&2
  exit 1
fi

current=$(kubectl -n "$namespace" get service "$service" -o jsonpath='{.spec.selector.color}')
if [[ "$current" == blue ]]; then
  previous=green
else
  previous=blue
fi

case "${ACTION:-}" in
  CONFIRM)
    kubectl -n "$namespace" scale deployment "demo-$previous" --replicas=0
    kubectl -n "$namespace" annotate service "$service" phase=release --overwrite
    echo "Release confirmed; demo-$previous scaled to zero"
    ;;
  ROLLBACK)
    kubectl -n "$namespace" patch service "$service" --type=merge \
      -p "{\"spec\":{\"selector\":{\"color\":\"$previous\"}}}"
    kubectl -n "$namespace" scale deployment "demo-$current" --replicas=0
    kubectl -n "$namespace" annotate service "$service" phase=release --overwrite
    echo "Rolled back to $previous; demo-$current scaled to zero"
    ;;
  *)
    echo "ACTION must be CONFIRM or ROLLBACK" >&2
    exit 1
    ;;
esac
