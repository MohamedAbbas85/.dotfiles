#!/bin/bash

set -euo pipefail

remote_host="mohamed@homeserver.fritz.box"
remote_script="/home/mohamed/.dotfiles/bin/borg-backup.sh"

exec ssh "${remote_host}" "${remote_script}"

