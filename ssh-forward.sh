#!/bin/bash

# Configuration variables
BASTION_NAME="bastion"        # Name of the Azure Bastion host
RESOURCE_GROUP="core-rg"  # Azure resource group name
TARGET_VM_PORT=22               # Target port on the VM (commonly SSH port 22)

# Arrays of target resource IDs and local ports
# Example arrays:
# TARGET_RESOURCE_IDS=("10.0.0.1" "10.0.0.2" "10.0.0.3")
# LOCAL_PORTS=(8000 8001 8002)
TARGET_RESOURCE_IDS=("/subscriptions/cd81f212-6d7c-4937-86e7-b043fc7a4efe/resourceGroups/core-rg/providers/Microsoft.Compute/virtualMachines/pg-cluster-0")
LOCAL_PORTS=(5010)

# Length of the arrays
NUM_HOSTS=${#TARGET_RESOURCE_IDS[@]}

# Check if both arrays are of the same length
if [ ${#LOCAL_PORTS[@]} -ne $NUM_HOSTS ]; then
    echo "Error: The number of target resource IDs and local ports must be the same."
    exit 1
fi

# Loop through the arrays
for (( i=0; i<$NUM_HOSTS; i++ ))
do
    # Fetch the current target resource ID and local port from arrays
    current_ip=${TARGET_RESOURCE_IDS[$i]}
    current_port=${LOCAL_PORTS[$i]}

    # Set up port forwarding
    echo "Setting up port forwarding for $current_ip on local port $current_port"
    az network bastion tunnel --name "$BASTION_NAME" --resource-group "$RESOURCE_GROUP" \
                              --target-resource-id "$current_ip" --resource-port "$TARGET_VM_PORT" \
                              --port "$current_port"
done
