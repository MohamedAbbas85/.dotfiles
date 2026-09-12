#!/bin/bash

set -e
set -x  # Print commands as they run

NEWUSER="mohamed"
SSH_PORT=2222  # Change if you want to keep port 22

# 1. Create new user with sudo privileges (no password)
useradd -m -d /home/$NEWUSER -s /bin/bash $NEWUSER
usermod -aG sudo $NEWUSER

# Add user to the docker group for Docker access without sudo
usermod -aG docker $NEWUSER

echo "$NEWUSER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$NEWUSER
chmod 440 /etc/sudoers.d/$NEWUSER

# 2. Setup SSH keys (copy from root)
mkdir -p /home/$NEWUSER/.ssh
cp /root/.ssh/authorized_keys /home/$NEWUSER/.ssh/authorized_keys
chmod 700 /home/$NEWUSER/.ssh
chmod 600 /home/$NEWUSER/.ssh/authorized_keys
chown -R $NEWUSER:$NEWUSER /home/$NEWUSER/.ssh

# 3. Secure SSH: disable root login, disable password auth, change port
sed -i '/^#\?PermitRootLogin/s/.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i '/^#\?PasswordAuthentication/s/.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i "/^#\?Port/s/.*/Port $SSH_PORT/" /etc/ssh/sshd_config
systemctl restart ssh

# 4. Update system and install packages
apt update && apt upgrade -y
apt install -y git curl wget vim ufw fail2ban tmux ca-certificates

# 5. Install Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
| tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker --now

# 6. Enable and configure firewall
ufw allow $SSH_PORT/tcp
ufw allow 80/tcp
ufw allow 443/tcp
yes | ufw enable

# 7. Enable fail2ban
systemctl enable fail2ban --now

# 8. Reboot to finalize
reboot
