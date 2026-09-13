#!/bin/bash

# install systemd services
set -euo pipefail

cd "$(dirname "$(realpath "$0")")"
mkdir -p "$HOME/.config/systemd"
stow --target "$HOME/.config/systemd" systemd
systemctl --user daemon-reload
systemctl --user enable --now nas-backup.timer

# install Samba configuration
sudo mkdir -p /etc/samba
sudo stow --target /etc/samba samba



