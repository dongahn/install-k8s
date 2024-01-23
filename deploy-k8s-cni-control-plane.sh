#!/bin/bash

# This script deploys the Kubernetes CNI control plane.
# It applies the necessary YAML files to install the CNI plugin.
# Uncomment the appropriate line to choose the desired CNI plugin.

# Deploy Calico CNI
# kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

# Deploy Flannel CNI
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
#!/bin/bash

#kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml


