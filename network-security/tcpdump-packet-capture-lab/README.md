# 📡 Packet Capture with tcpdump: Linux CLI Network Analysis Lab

[![Platform: Linux CLI](https://img.shields.io/badge/Platform-Linux%20CLI%20%2F%20Bash-orange.svg)](#)
[![Tool: tcpdump](https://img.shields.io/badge/Tool-tcpdump-blue.svg)](#)
[![Focus: Packet Capture](https://img.shields.io/badge/Focus-Packet%20Capture-red.svg)](#)
[![Role: SOC Analyst](https://img.shields.io/badge/Role-SOC%20Analyst-green.svg)](#)

## 📌 Overview
Hands-on lab in which I captured and analysed live network traffic from a Linux machine using **tcpdump**. Unlike Wireshark, tcpdump needs no GUI, so it is the go-to tool on servers where you only have a shell. The workflow: identify the network interface → watch live traffic → save a filtered capture to a `.pcap` file → analyse the file offline.

A command reference is in [`COMMANDS.md`](COMMANDS.md).

## 🧭 Walkthrough

### Task 1 – Identify network interfaces
```bash
sudo ifconfig      # shows interfaces: eth0 (Ethernet) and lo (loopback)
sudo tcpdump -D    # lists interfaces tcpdump can capture on (works where ifconfig is missing)
```
`eth0` is the Ethernet interface used for all captures in this lab; `lo` is loopback (127.0.0.1).

### Task 2 – Inspect live traffic
```bash
sudo tcpdump -i eth0 -v -c5
```
| Option | Meaning |
|---|---|
| `-i eth0` | Capture on the `eth0` interface |
| `-v` | Verbose: show IP header details (TTL, flags, protocol, length) |
| `-c5` | Stop after 5 packets |

**Reading a line of output**
```
10:57:33.427749 IP (tos 0x0, ttl 64, id 35057, offset 0, flags [DF], proto TCP (6), length 134)
  7acb26dc1f44.5000 > nginx-us-east1-c...internal.59788: Flags [P.], seq 1080713945:1080714027, ack 62760789, win 501, length 82
```
- **Timestamp and protocol:** `10:57:33.427749 IP`
- **IP header (`-v`):** TTL, fragmentation flags, inner protocol (`TCP (6)`), packet length
- **Endpoints:** `source.port > destination.port`. The arrow shows the direction of travel.
- **TCP header:** `Flags [P.]` means PSH + ACK (the packet is pushing data), plus checksum, sequence/ack numbers, window size, payload length

> By default tcpdump converts IPs and ports to names, which is why hostnames appear above.

### Task 3 – Capture traffic to a file
```bash
sudo tcpdump -i eth0 -nn -c9 port 80 -w capture.pcap &   # capture 9 packets of HTTP in the background
curl opensource.google.com                                # generate HTTP traffic
ls -l capture.pcap                                        # verify the file exists
```
| Option | Meaning |
|---|---|
| `-nn` | Don't resolve IPs or ports to names |
| `-c9` | Capture 9 packets, then exit |
| `port 80` | Capture filter: only HTTP traffic |
| `-w capture.pcap` | Write raw packets to a file |
| `&` | Run in the background so the same terminal can run `curl` |

**Why `-nn` matters:** name lookups generate extra network traffic (e.g. DNS queries) that can reveal an investigation to an attacker who controls the name server, and the results may not be trustworthy. It also keeps output faster and shows the raw addresses and port numbers.

### Task 4 – Analyse the saved capture offline
```bash
sudo tcpdump -nn -r capture.pcap -v   # header details of each packet
sudo tcpdump -nn -r capture.pcap -X   # hex + ASCII dump of the packet contents
```
- `-r` reads from a file instead of the network.
- Example from the capture: `172.17.0.2:46498 > 146.75.38.132:80: Flags [S]` is a **SYN**, the first step of the TCP three-way handshake. The reply carries `[S.]` (SYN-ACK).
- `-X` shows the packet bytes in hex and ASCII, so readable content such as HTTP requests can be inspected, and patterns or anomalies can be spotted in forensic or malware analysis.

## 🔎 Observations
- Output lines show `cksum ... (incorrect)` on outgoing packets. This is commonly caused by **checksum offloading** (the network card calculates the checksum after tcpdump sees the packet), so it isn't automatically a sign of tampering.
- `-c` limits how *many* packets are captured, which keeps captures small and predictable. A capture filter such as `port 80` reduces both noise and file size.
- Port 80 traffic is unencrypted, so `-X` reveals its contents. HTTPS traffic would only show encrypted payloads.

## 🧠 Skills Demonstrated
Identifying interfaces · live packet capture · BPF capture filters · saving and re-reading PCAPs · reading IP/TCP header fields and flags · understanding the TCP handshake in raw output · safe capture practice (`-nn`).

## 📁 Repository Structure
```
.
├── README.md     # lab write-up
└── COMMANDS.md   # tcpdump command reference
```
