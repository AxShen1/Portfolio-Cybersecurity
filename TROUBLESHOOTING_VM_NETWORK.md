# 🌐 Troubleshooting: slow internet inside a VirtualBox VM

**Situation:** my first Kali VM (custom install) had very slow internet. I didn't pin down the cause before switching to a pre-built image, so this document is a **checklist of common causes** to test one at a time, not a diagnosis.

## 0. My configuration (relevant facts)
- Host: Windows PC on **wired Ethernet** (Realtek PCIe GbE), so Wi-Fi bridging issues are unlikely.
- Both VMs use a **bridged** adapter. The Kali image uses a paravirtualised (**virtio-net**) adapter; Windows 11 uses **Intel PRO/1000 MT Desktop**.
- I don't know which adapter type the first, slow Kali install used. Worth comparing.

## 1. Measure first
Run [`scripts/vm_health_check.sh`](../scripts/vm_health_check.sh) inside the VM. It prints DNS lookup time, IPv4 vs IPv6 reachability and a download timing.

| Observation | Suggests |
|---|---|
| Pinging an IP is fast but names resolve slowly | DNS problem |
| IPv4 fast, IPv6 slow or timing out | IPv6 route/DNS issue |
| Everything slow, including IPs | adapter type, host load, or host network |

## 2. Things to check (one change at a time)
1. **Network mode:** NAT is the simplest for internet access; bridged depends on the host adapter and Wi-Fi.
2. **Adapter type** (VM → Settings → Network → Advanced): try *Intel PRO/1000* vs *virtio-net*.
3. **DNS:** compare the DNS server the VM uses with `resolvectl status` or `cat /etc/resolv.conf`; try a public resolver temporarily.
4. **IPv6:** if IPv6 is the slow path, test with IPv4 only (`curl -4 ...`) before disabling anything.
5. **Mirror/repository:** a slow `apt` mirror looks like slow internet; try another mirror.
6. **Host resources:** CPU/RAM given to the VM, virtualisation enabled (VT-x/AMD-V), other VMs running.
7. **Guest Additions / VirtualBox version** mismatches.
8. **VPN or security software on the host** that interferes with NAT.

## 3. Record
For each test write: what I changed, the measured result, and whether I reverted it.
