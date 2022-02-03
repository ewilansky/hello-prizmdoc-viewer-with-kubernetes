#!/bin/sh

namespace=prizmdoc
docserver="prizmdoc-server 18681:18681"

case "$1" in
    deploy)
        kubectl create namespace prizmdoc --dry-run=client -o yaml | kubectl apply -f -
        kubectl apply --filename ./prizmdoc-viewer-app-minimal --namespace ${namespace}
        ;;
    remove)
        kubectl delete --filename ./prizmdoc-viewer-app-minimal --namespace ${namespace}
        kubectl delete ns prizmdoc
        # end port-forwarding
        killall kubectl
        ;;
    portforward)
        kubectl -n ${namespace} port-forward service/${docserver} 2>&1 >/dev/null &
        echo "Admin status at: http://localhost:18681/admin"
        ;;
    
    "")
        echo "\tNo argument provided:
        * deploy - to install the service to Kubernetes
        * portforward - to forward PAS and DocServer locally
        * remove - to delete the services and end port forwarding"
        ;;
    *)
        echo "\tInvalid argument, must be:
        * deploy - to install the service to Kubernetes
        * portforward - to forward PAS and DocServer locally
        * remove - to delete the services and end port forwarding"
        ;;
esac