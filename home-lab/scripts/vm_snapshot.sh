#!/usr/bin/env bash
# vm_snapshot.sh - small wrapper around VBoxManage snapshots.
# Usage:
#   ./vm_snapshot.sh list    "<vm name>"
#   ./vm_snapshot.sh take    "<vm name>" <snapshot-name> [--apply]
#   ./vm_snapshot.sh restore "<vm name>" <snapshot-name> [--apply]
# take/restore are DRY RUN unless --apply is given (restore discards the VM's
# current state, so it should never happen by accident).
# NOTE: tested only against a stand-in VBoxManage, not a real VirtualBox install.
set -euo pipefail

command -v VBoxManage >/dev/null 2>&1 || { echo "[!] VBoxManage not found in PATH." >&2; exit 2; }
[ "$#" -ge 2 ] || { sed -n '2,10p' "$0"; exit 2; }

ACTION="$1"; VM="$2"; SNAP="${3:-}"; APPLY="${4:-}"
NAME_RE='^[A-Za-z0-9._ -]{1,64}$'
[[ "$VM" =~ $NAME_RE ]] || { echo "[!] Invalid VM name." >&2; exit 2; }
if [ -n "$SNAP" ]; then
    [[ "$SNAP" =~ $NAME_RE ]] || { echo "[!] Invalid snapshot name." >&2; exit 2; }
fi

run() {
    if [ "$APPLY" = "--apply" ]; then echo "+ $*"; "$@"; else echo "(dry run) $*"; fi
}

case "$ACTION" in
    list)    VBoxManage snapshot "$VM" list --details ;;
    take)    [ -n "$SNAP" ] || { echo "[!] Snapshot name required." >&2; exit 2; }
             run VBoxManage snapshot "$VM" take "$SNAP" --description "taken $(date -u +%FT%TZ)" ;;
    restore) [ -n "$SNAP" ] || { echo "[!] Snapshot name required." >&2; exit 2; }
             run VBoxManage snapshot "$VM" restore "$SNAP" ;;
    *)       echo "[!] Unknown action: $ACTION" >&2; exit 2 ;;
esac
