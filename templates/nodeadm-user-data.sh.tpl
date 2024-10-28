#!/bin/bash
set -e

# Parse the JSON-encoded pre_bootstrap_user_data
eval "$(jq -r '@sh "CLUSTER_NAME=\(.cluster_name) CLUSTER_ENDPOINT=\(.cluster_endpoint) CLUSTER_CA_CERTIFICATE=\(.cluster_ca_certificate) CLUSTER_SERVICE_CIDR=\(.cluster_service_cidr) CLUSTER_POD_CIDR=\(.cluster_pod_cidr) CLUSTER_DNS=\(.cluster_dns) KUBELET_EXTRA_ARGS=\(.kubelet_extra_args)"' <<< '${pre_bootstrap_user_data}')"

# Install NodeADM if not already installed
if ! command -v nodeadm &> /dev/null; then
    yum install -y nodeadm
fi

# Configure NodeADM
cat << EOF > /etc/nodeadm/nodeadm.yaml
apiVersion: node.eks.aws.k8s.io/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: $CLUSTER_NAME
    apiServerEndpoint: $CLUSTER_ENDPOINT
    caBundle: $CLUSTER_CA_CERTIFICATE
    cidr: $CLUSTER_SERVICE_CIDR
  kubelet:
    extraArgs:
      $KUBELET_EXTRA_ARGS
  network:
    podCIDR: $CLUSTER_POD_CIDR
  dns:
    clusterDNS:
      - $CLUSTER_DNS
EOF

# Initialize the node
nodeadm init --config /etc/nodeadm/nodeadm.yaml

# Enable and start kubelet service
systemctl enable kubelet
systemctl start kubelet

# Allow user-provided userdata code
${additional_userdata}
