# 🧪 Home Cybersecurity Lab (VirtualBox: Kali Linux + Windows 11)

[![Hypervisor: VirtualBox](https://img.shields.io/badge/Hypervisor-Oracle%20VirtualBox-blue.svg)](#)
[![Attacker VM: Kali Linux](https://img.shields.io/badge/VM-Kali%20Linux-557C94.svg)](#)
[![Target VM: Windows 11](https://img.shields.io/badge/VM-Windows%2011-0078D4.svg)](#)
[![Status: In progress](https://img.shields.io/badge/Status-In%20progress-yellow.svg)](#)

## 📌 Overview
I'm building my own isolated lab so I can practise security skills on machines I own, instead of only using course environments. This repo documents **how I built it, what went wrong, what I changed and what I learned**, plus the small helper scripts and checklists I wrote along the way.

> I'm a beginner. This documents a real learning process, including mistakes. Nothing here should be used against systems you don't own or have permission to test.

## 🗺️ Lab layout
```
┌──────────────── Host PC (Windows, wired Ethernet) ────────────────┐
│  Oracle VirtualBox 7.x                                            │
│   ┌───────────────┐                  ┌────────────────────┐       │
│   │  Kali Linux   │                  │  Windows 11        │       │
│   │  (tools)      │                  │  (debloated)       │       │
│   └───────┬───────┘                  └─────────┬──────────┘       │
│           └──── both on a BRIDGED adapter ─────┘                  │
└──────────────────────────────┬────────────────────────────────────┘
                               ▼
                    Home network / router / internet
```
> **Current state:** both VMs use a *bridged* adapter, which puts them directly on my home network. That is convenient for internet access but not ideal for a security lab (see [Security decisions](#-security-decisions-i-made) and *Next steps*).

## ⚙️ VM configuration
| | **Kali Linux** | **Windows 11** |
|---|---|---|
| Image | `kali-linux-2026.2-virtualbox-amd64` (official pre-built, `.vdi`) | Fresh install, then debloated |
| Guest type | Debian (64-bit) | Windows 11 (64-bit) |
| RAM | ~8 GB (8048 MB) | ~6.6 GB (6743 MB) |
| CPUs | 2 | 4 |
| Disk | 80.09 GB (dynamic `.vdi`) | 49.62 GB (`.vdi`) |
| Firmware | default | EFI, **Secure Boot on**, **TPM 2.0** |
| Acceleration | Nested paging, PAE/NX, KVM paravirtualisation | Nested paging, Hyper-V paravirtualisation |
| Graphics | VMSVGA, 128 MB | VBoxSVGA, 128 MB |
| Audio | ICH AC97 | Intel HD Audio |
| Network | Bridged (host Realtek PCIe GbE), **paravirtualised (virtio-net)** adapter | Bridged (host Realtek PCIe GbE), **Intel PRO/1000 MT Desktop** adapter |
| Extras | none | VirtualBox Guest Additions 7.2.14 mounted |
| Remote desktop / recording | off | off |

## 🛠️ What I did (build log)
1. **Installed Oracle VirtualBox** on my PC.
2. **Kali, attempt 1: custom install.** I installed Kali manually with a minimal package selection instead of the all-in-one image, to understand what is installed and why. I configured it fully.
3. **Changed the credentials I had set.** I decided the password I picked wasn't good enough, so I changed both the password and the username.
4. **Problem: very slow internet inside the VM.** Updates and downloads were painfully slow. I didn't find the root cause, so I moved on to the pre-built image (see [`docs/TROUBLESHOOTING_VM_NETWORK.md`](docs/TROUBLESHOOTING_VM_NETWORK.md) for what I'd check, and the script that measures it).
5. **Kali, attempt 2: official pre-built image.** Imported into VirtualBox. Because these images ship with well-known default credentials, **I changed both the username and password right away**.
6. **Windows 11 VM.** Installed and configured it, then **debloated** it (removed unneeded apps and background components) to get a lighter, quieter lab machine.

## 🔐 Security decisions I made
- **No default credentials left in place.** Pre-built images use public defaults, so they are the first thing an attacker (or scanner) tries.
- **Passwords are not stored in this repo, notes or screenshots.** I use a password manager.
- **Lab VMs are separate from my daily system.** Anything risky happens inside a VM.
- **Known weakness:** both VMs are on a **bridged** adapter, so they appear as normal devices on my home LAN. Kali and a debloated Windows are fine to browse and update from there, but I should **not** run intentionally vulnerable machines or noisy scans in this mode. Fix: move lab-to-lab traffic to a host-only/internal network and keep NAT for updates.
- **Windows VM keeps Secure Boot and TPM 2.0 enabled**, which matches the Windows 11 requirements and keeps the lab closer to a real endpoint.
- **Debloating is for the lab only.** It can break updates and security features, so I don't treat the debloated VM as a model of a hardened production system.

More detail: [`docs/SECURITY_CHECKLIST.md`](docs/SECURITY_CHECKLIST.md).

## 📚 What I learned
- **Custom install vs pre-built image:** a custom install teaches much more about what's on the system, but costs time. A pre-built image is faster but you inherit defaults you must change.
- **Default credentials are a real risk**, even in a lab. Changing them is the first step after import.
- **Virtual networking matters.** Slow internet in a VM is often a network-mode, DNS or IPv6 issue rather than "the VM is bad". Measuring beats guessing.
- **Snapshots are the lab's safety net.** Take one before every risky change.
- **Debloating is a trade-off** between a lighter system and a smaller, but less supported, one.

## 🧰 Helper scripts
All three are small Bash scripts. Syntax-checked and tested with stand-ins where noted in the file.
| Script | Where it runs | What it does |
|---|---|---|
| [`scripts/verify_download.sh`](scripts/verify_download.sh) | Host (Linux/macOS/WSL/Git Bash) | Compares an ISO/image's SHA-256 with the hash published on the vendor's site |
| [`scripts/vm_snapshot.sh`](scripts/vm_snapshot.sh) | Host with `VBoxManage` | List, take and restore VirtualBox snapshots with input checks and a dry-run mode |
| [`scripts/vm_health_check.sh`](scripts/vm_health_check.sh) | Inside Kali | Read-only report: default accounts, listening ports, pending updates, DNS/IPv4/IPv6 speed |

## 🚧 Next steps
- Switch the VMs from bridged to **NAT + host-only (or internal) network** so targets have no exposure to my home network.
- Compare network speed between the two adapter types (virtio-net on Kali vs Intel PRO/1000 on Windows) with `scripts/vm_health_check.sh`.
- Install a vulnerable training target and practise scanning it from Kali.
- Collect logs from the Windows VM (Event Viewer, Sysmon) and analyse them.
- Write up each exercise as its own project in this portfolio.

## 📁 Repository Structure
```
.
├── README.md
├── docs/
│   ├── SECURITY_CHECKLIST.md
│   └── TROUBLESHOOTING_VM_NETWORK.md
└── scripts/
    ├── verify_download.sh
    ├── vm_snapshot.sh
    └── vm_health_check.sh
```
