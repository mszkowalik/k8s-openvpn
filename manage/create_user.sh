#!/bin/bash

if [ $# -ne 1 ]
then
  echo "Usage: $0 <CLIENT_KEY_NAME>"
  exit
fi

KEY_NAME=$1
NAMESPACE=openvpn
HELM_RELEASE=openvpn
POD_NAME=$(kubectl get pods -n "$NAMESPACE" -l "app=openvpn,release=$HELM_RELEASE" -o jsonpath='{.items[0].metadata.name}')
SERVICE_NAME=$(kubectl get svc -n "$NAMESPACE" -l "app=openvpn,release=$HELM_RELEASE" -o jsonpath='{.items[0].metadata.name}')
SERVICE_IP=$(kubectl get svc -n "$NAMESPACE" "$SERVICE_NAME" -o go-template='{{range $k, $v := (index .status.loadBalancer.ingress 0)}}{{$v}}{{end}}')
kubectl -n "$NAMESPACE" exec -it "$POD_NAME" /etc/openvpn/setup/newClientCert.sh "$KEY_NAME" "$SERVICE_IP"
# kubectl -n "$NAMESPACE" exec -it "$POD_NAME"  cat "/etc/openvpn/pki/$KEY_NAME.ovpn" > "$KEY_NAME.ovpn"
kubectl cp $NAMESPACE/$POD_NAME:/etc/openvpn/pki/$KEY_NAME.ovpn ./tmp/$KEY_NAME.ovpn