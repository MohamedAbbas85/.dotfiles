#!/usr/bin/env bash
set -euo pipefail

# ── Configuration ──────────────────────────────────────────────
SOURCE="/media/hdd"
BACKUP_MOUNT="/media/backup"
BACKUP_LABEL="Backup"
LOG_FILE="/var/log/backup-hdd.log"

# ── Helpers ────────────────────────────────────────────────────
log()  { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }
die()  { log "ERROR: $*"; exit 1; }

# ── Pre-flight checks ─────────────────────────────────────────
[[ $EUID -eq 0 ]] || die "Run as root (sudo)."

# Verify source is mounted and non-empty
mountpoint -q "$SOURCE" || die "Source $SOURCE is not mounted."
[[ -d "$SOURCE/data" ]]  || die "Expected $SOURCE/data not found."

# Find backup device by label
BACKUP_DEV=$(blkid -L "$BACKUP_LABEL" 2>/dev/null) \
    || die "No device with label '$BACKUP_LABEL' found."

# Mount backup drive if needed
if ! mountpoint -q "$BACKUP_MOUNT" 2>/dev/null; then
    log "Mounting $BACKUP_DEV → $BACKUP_MOUNT"
    mkdir -p "$BACKUP_MOUNT"
    mount "$BACKUP_DEV" "$BACKUP_MOUNT" || die "Failed to mount $BACKUP_DEV."
fi

# ── Rsync ──────────────────────────────────────────────────────
log "=== Backup started ==="
log "Source:      $SOURCE"
log "Destination: $BACKUP_MOUNT"

rsync -avh --delete --progress \
    --exclude='lost+found' \
    --exclude='immich-app/postgres' \
    "$SOURCE/" "$BACKUP_MOUNT/" \
    2>&1 | tee -a "$LOG_FILE"

log "=== Backup completed ==="

# ── Unmount (optional — comment out to keep mounted) ──────────
sync
umount "$BACKUP_MOUNT" && log "Unmounted $BACKUP_MOUNT"
