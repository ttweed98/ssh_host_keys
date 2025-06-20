Conversation opened. 1 unread message. 

Skip to content
Using Gmail with screen readers

2 of 83,987
ssh script to add host keys
Inbox

Tweed, Tony Anthony
Attachments
2:35 PM (10 minutes ago)
to me

 

 

Tony Tweed | Senior Network Engineer

Koch KGS

O 316.828.0949 |  C 248.706.8489

www.kochinc.com

 

Koch logo on blue box

 

 One attachment
  •  Scanned by Gmail
Great!Here you go!Fixed!
#!/bin/bash

# SSH Key Setup Script for SDWAN Devices
# This script adds SSH keys for all devices in inventory before running Ansible

INVENTORY_FILE="inventory/inventory.ini"
SSH_USER=""
SSH_PASS=""

echo "Setting up SSH keys for all SDWAN devices..."
echo "============================================"

# Extract all ansible_host IPs from inventory
HOSTS=$(grep "ansible_host=" "$INVENTORY_FILE" | sed 's/.*ansible_host=\([^ ]*\).*/\1/')

for HOST in $HOSTS; do
    echo "Processing: $HOST"
    
    # Check if host key already exists
    if ssh-keygen -F "$HOST" >/dev/null 2>&1; then
        echo "  ✅ SSH key already exists for $HOST"
    else
        echo "  🔑 Adding SSH key for $HOST..."
        
        # Use ssh-keyscan to get the host key
        ssh-keyscan -H "$HOST" >> ~/.ssh/known_hosts 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo "  ✅ SSH key added successfully for $HOST"
        else
            echo "  ❌ Failed to add SSH key for $HOST (host may be unreachable)"
        fi
    fi
done

echo ""
echo "SSH key setup complete!"
echo "You can now run the Ansible playbook without manual SSH connections."
ssh.sh
Displaying ssh.sh
