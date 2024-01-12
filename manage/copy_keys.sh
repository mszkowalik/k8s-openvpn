#!/bin/bash

KEY_NAME=$1
NAMESPACE=openvpn
HELM_RELEASE=openvpn
POD_NAME=$(kubectl get pods -n "$NAMESPACE" -l "app=openvpn,release=$HELM_RELEASE" -o jsonpath='{.items[0].metadata.name}')

kubectl exec "$POD_NAME" -n "$NAMESPACE" "$POD_NAME" -- sh -c "mkdir -p /tmp/outfiles && cp /etc/openvpn/pki/*.ovpn /tmp/outfiles/"
# kubectl cp "sites/$TARGET_POD:/tmp/outfiles/." .
kubectl cp $NAMESPACE/$POD_NAME:/tmp/outfiles/. ./tmp
kubectl exec "$POD_NAME" -n "$NAMESPACE" "$POD_NAME" -- sh -c "rm -r /tmp/outfiles/"