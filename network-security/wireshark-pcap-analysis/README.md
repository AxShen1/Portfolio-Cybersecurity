# 🦈 Network Traffic Analysis with Wireshark: PCAP Triage Lab

[![Tool: Wireshark](https://img.shields.io/badge/Tool-Wireshark-blue.svg)](#)
[![Focus: PCAP Analysis](https://img.shields.io/badge/Focus-PCAP%20Analysis-red.svg)](#)
[![Protocols: TCP/IP, DNS, ICMP](https://img.shields.io/badge/Protocols-TCP%2FIP%20%7C%20DNS%20%7C%20ICMP-green.svg)](#)
[![Role: SOC Analyst](https://img.shields.io/badge/Role-SOC%20Analyst-orange.svg)](#)

## 📌 Overview
Hands-on lab in which I played a security analyst investigating a user's web-browsing session. Using **Wireshark** on a sample capture (`sample.pcap`), I applied display filters to identify the hosts involved, the protocols used, and the type of data exchanged. Filters I used are collected in [`FILTERS.md`](FILTERS.md).

**Goals**
- Identify source and destination IP addresses of the session.
- Examine the protocols used to reach the website.
- Inspect individual packets to see what was sent and received.

## 🧭 Walkthrough

### 1. Getting oriented
The packet list shows `No.`, `Time`, `Source`, `Destination`, `Protocol`, `Length`, and `Info`. Colouring rules help classify traffic at a glance: light blue for DNS, green for TCP/HTTP, pink for ICMP. Scrolling the list showed an **ICMP** echo (ping) request.

### 2. Inspecting a packet (layer by layer)
Filter: `ip.addr == 142.250.1.139` → opened the first TCP packet and expanded each layer in the details pane:

| Layer | What it shows |
|---|---|
| **Frame** | Whole-packet info: length, arrival time |
| **Ethernet II** | Source/destination MAC addresses, inner protocol type |
| **IPv4** | Source/destination IPs, TTL, header length, inner protocol (TCP/UDP/ICMP) |
| **TCP** | Source/destination ports, sequence numbers, flags |

Finding: the TCP destination port was **80** (HTTP).

### 3. Filtering by IP and MAC address
| Filter | Result |
|---|---|
| `ip.src == 142.250.1.139` | Only packets sent *from* that host |
| `ip.dst == 142.250.1.139` | Only packets sent *to* that host |
| `eth.addr == 42:01:ac:15:e0:02` | All traffic for one MAC at layer 2, whatever the IP or protocol |

Finding: the first packet for that MAC carried **UDP** in its IPv4 protocol field (the DNS lookup).

### 4. DNS analysis
Filter: `udp.port == 53`. In the first packet, `Domain Name System (query) → Queries` shows the name that was looked up: **`opensource.google.com`**. In the response packet, `Answers` shows the resolved address: **`142.250.1.139`**, the same host seen in the web traffic above.

### 5. TCP and payload search
Filter: `tcp.port == 80` → web traffic to `http://opensource.google.com`. The first packet went to **`169.254.169.254`** with **TTL 64**, **frame length 54 bytes**, **IPv4 header length 20 bytes**.

Filter: `tcp contains "curl"` → packets whose payload contains the text *curl*, meaning web requests made with the `curl` command-line tool rather than a browser.

## 🔎 Analyst Observations
- **The full story is reconstructable from filters alone:** DNS lookup (`opensource.google.com` → `142.250.1.139`), then HTTP requests over TCP port 80.
- **Traffic to `169.254.169.254`:** this is a link-local address that cloud platforms use for their instance metadata service. In a real investigation, requests to it from an unexpected process deserve a closer look, because metadata endpoints can expose credentials.
- **`curl` in the payload:** a command-line tool as the HTTP client is not malicious by itself, but it can indicate scripted or automated activity. Context decides whether it is normal admin work or something to escalate.
- **Port 80 means plain HTTP:** everything is readable in the capture, which is why `tcp contains` works. HTTPS traffic would need a different approach (metadata, SNI, or decryption).
- **TTL 64** is the common default for Linux hosts; it can hint at the OS of the sender but is easily changed, so it is a clue, not proof.

## 🧠 Skills Demonstrated
Reading PCAPs in Wireshark · writing display filters · understanding the Ethernet / IP / TCP / UDP layering · DNS query and answer analysis · payload text searching · drawing careful conclusions from network evidence.

## 📁 Repository Structure
```
.
├── README.md    # lab write-up and findings
└── FILTERS.md   # Wireshark display-filter cheat sheet
```
