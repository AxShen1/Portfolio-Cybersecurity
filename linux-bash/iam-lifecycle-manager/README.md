# 👥 Linux IAM User Lifecycle (Onboard → Offboard)

[![Concept: IAM / RBAC](https://img.shields.io/badge/Concept-IAM%20%26%20RBAC-blue.svg)](#)
[![Platform: Linux / Bash](https://img.shields.io/badge/Platform-Linux%20%2F%20Bash-orange.svg)](#)

## 📌 Overview
Managing the whole identity lifecycle helps avoid orphaned ("ghost") accounts and stray permissions, which are common weak points on servers. [`iam_lifecycle_manager.sh`](iam_lifecycle_manager.sh) walks one example user (`researcher9`) through four phases:

| Phase | Commands | Purpose |
|---|---|---|
| 1. Onboarding | `useradd`, `usermod -g` | Create the account and set the primary (role) group |
| 2. Asset delegation | `chown` | Transfer ownership of a project file to the new user |
| 3. Role expansion | `usermod -aG` | **Append** a supplementary group without dropping existing ones |
| 4. Offboarding | `userdel`, `groupdel` | Remove the account and its leftover personal group |

## ⚠️ Safe by default
The script is a **dry run** unless you pass `--apply`. Dry run only prints the commands. `--apply` really creates and deletes an account, so use it only on a disposable lab VM or container, as root, and after creating the groups `research_team` and `sales_team`.

```bash
./iam_lifecycle_manager.sh            # dry run: prints what would happen
sudo ./iam_lifecycle_manager.sh --apply
```

## 📝 Notes from testing
- `usermod -g` replaces the primary group; `-aG` adds to the others. Forgetting `-a` is a classic mistake that silently removes the user from their other groups.
- Because the primary group was changed in phase 1, `userdel` leaves the user's personal group behind, which is why `groupdel` is a separate step.
- In real offboarding, files still owned by the user become orphaned. Reassign or archive them *before* deleting the account.

## 🧠 Skills Demonstrated
Linux user and group management · RBAC concepts · dry-run pattern in Bash · defensive scripting (pre-checks, root check).
