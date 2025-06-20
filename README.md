# SSH Host Key Setup Script

## Overview

The `ssh.sh` script automatically adds SSH host keys for all network devices in your Ansible inventory. This prevents SSH host key verification prompts and connection failures when running playbooks.

## Purpose

When Ansible connects to network devices for the first time, SSH requires host key verification. Without pre-established host keys, connections may fail with "Host key verification failed" errors. This script automates the process of adding host keys for all devices in your inventory.

## How It Works

1. **Reads Inventory**: Extracts all `ansible_host` IP addresses from your inventory file
2. **Checks Existing Keys**: Verifies if SSH keys already exist for each host
3. **Adds Missing Keys**: Uses `ssh-keyscan` to retrieve and store host keys
4. **Reports Status**: Shows success/failure for each device

## Prerequisites

- SSH client tools (`ssh-keyscan`, `ssh-keygen`)
- Network connectivity to all devices
- Ansible inventory file with `ansible_host` entries

## Usage

### Basic Usage
```bash
chmod +x ssh.sh
./ssh.sh
```

## Expected Output

```
Setting up SSH keys for all devices...
============================================
Processing: 10.0.0.1
  🔑 Adding SSH key for 10.0.0.1...
  ✅ SSH key added successfully
Processing: 10.0.0.2
  ✅ SSH key already exists
Processing: 10.0.0.2
  ❌ Failed to add SSH key (host may be unreachable)

SSH key setup complete!
You can now run the Ansible playbook without manual SSH connections.
```

## Files Modified

- **`~/.ssh/known_hosts`**: SSH host keys are added to this file
- **No device configuration changes**: Script only modifies local SSH client

## Error Handling

### Unreachable Hosts
- **Symptom**: "Failed to add SSH key"
- **Cause**: Network connectivity issues or device down
- **Solution**: Check network connectivity and device status

### Permission Issues
- **Symptom**: "Permission denied"
- **Cause**: SSH key file permissions
- **Solution**: Ensure `~/.ssh/known_hosts` is writable

### DNS Resolution
- **Symptom**: "Name resolution failed"
- **Cause**: FQDN not resolvable
- **Solution**: Use IP addresses in inventory or fix DNS

## Security Considerations

- **Host Key Verification**: Script accepts any host key (bypass verification)
- **Network Trust**: Only run on trusted networks
- **Key Storage**: Keys stored in standard SSH location (`~/.ssh/known_hosts`)

## Troubleshooting

### Manual SSH Key Addition
If the script fails, you can manually add keys:
```bash
ssh-keyscan -H 10.0.0.l >> ~/.ssh/known_hosts
```

### Clear Existing Keys
To remove old/invalid keys:
```bash
ssh-keygen -R 10.0.0.1
```

### Verify Key Addition
Check if key was added successfully:
```bash
ssh-keygen -F 10.0.0.1
```

## Integration Notes

- **Called automatically** by `ssh.sh`
- **Safe to run multiple times** (checks for existing keys)
- **Optional step** (can disable by removing script)

## Alternative Approaches

If you prefer not to use this script, you can:

1. **Disable host key checking** in `ansible.cfg`:
   ```ini
   [defaults]
   host_key_checking = false
   ```

2. **Manual SSH connections** before running Ansible:
   ```bash
   ssh admin@10.0.0.1
   # Accept host key prompt, then exit
   ```

## File Location

Place the script in your playbook directory:
```
Ansible/playbooks/
├── ssh_key_setup.sh         # This script
├── sample_playbook.yml  # Sample ansible playbook
└── inventory/
    └── inventory.ini        # Device inventory
```

## Support

The script is designed to be robust and handle common edge cases. If you encounter issues:

1. **Check network connectivity** to devices
2. **Verify inventory file format** (contains `ansible_host=` entries)
3. **Run with verbose output** to debug connection issues
4. **Check SSH client tools** are installed and working

---

**Note**: This script enhances the reliability of the SDWAN VRF analysis automation by eliminating SSH host key verification prompts.
ssh_README.md
Displaying ssh_README.md.
