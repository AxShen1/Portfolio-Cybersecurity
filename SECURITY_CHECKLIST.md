# ✅ Lab Security Checklist

A checklist I use for every VM in my home lab.

## Before installing
- [ ] Download ISOs/images only from the vendor's official site.
- [ ] Verify the SHA-256 checksum (`scripts/verify_download.sh`).
- [ ] Use a licensed or officially provided evaluation Windows image.

## Right after installing
- [ ] **Change default credentials** (pre-built Kali images ship with a publicly known default login).
- [ ] Use a unique, long password from a password manager. Never reuse a host or personal password.
- [ ] Don't enable auto-login, and don't expose SSH unless needed. If enabled, use keys.
- [ ] Update the system (`sudo apt update && sudo apt full-upgrade` on Kali).
- [ ] Install VirtualBox Guest Additions only if needed.
- [ ] **Take a "clean baseline" snapshot.**

## Isolation (VirtualBox)
- [ ] Attacker and target VMs talk over a **host-only or internal network**, not bridged.
- [ ] Never put an intentionally vulnerable VM on a bridged adapter (it would be visible on my home network).
- [ ] *Status: my VMs are currently bridged, so this item is still open.*
- [ ] Disable shared clipboard, drag-and-drop and shared folders when handling suspicious files.
- [ ] Don't run lab tools against anything I don't own.

## Windows 11 VM (debloated)
- [ ] Keep Microsoft Defender and Windows Update unless I turn them off *on purpose* for a specific exercise.
- [ ] Record exactly what was removed or disabled (so changes can be reproduced or undone).
- [ ] Treat the VM as disposable. Never sign in with my real Microsoft account.

## Repo and screenshots hygiene
- [ ] No passwords, product keys, tokens, usernames of real accounts, or personal IPs in commits or screenshots.
- [ ] Review `git diff` before every push.
