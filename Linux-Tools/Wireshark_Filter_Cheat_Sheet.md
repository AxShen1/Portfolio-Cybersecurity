# 📖 Wireshark Display Filter Cheat Sheet

## Used in this lab
| Filter | Purpose |
|---|---|
| `ip.addr == 142.250.1.139` | All traffic to or from an IP |
| `ip.src == 142.250.1.139` | Traffic *from* an IP |
| `ip.dst == 142.250.1.139` | Traffic *to* an IP |
| `eth.addr == 42:01:ac:15:e0:02` | All traffic for a MAC address (layer 2) |
| `udp.port == 53` | DNS traffic |
| `tcp.port == 80` | Plain HTTP web traffic |
| `tcp contains "curl"` | TCP payloads containing the text "curl" |

## Additional filters (not part of the lab)
| Filter | Purpose |
|---|---|
| `icmp.type == 8` | ICMP echo requests (ping) |
| `dns.qry.name == "opensource.google.com"` | DNS queries for one name |
| `http.request.method == "GET"` | HTTP GET requests |
| `http.user_agent contains "curl"` | More precise than `tcp contains`: matches the HTTP User-Agent header |
| `tcp.flags.syn == 1 && tcp.flags.ack == 0` | Connection attempts (SYN packets) |
| `ip.ttl == 64` / `frame.len < 100` | Filter on packet fields |
| `ip.addr == 10.0.0.5 && tcp.port == 80` | Combine conditions with `&&` |
| `!(arp \|\| dns)` | Exclude noise with `!` and `\|\|` |

## Operators
| Operator | Meaning |
|---|---|
| `==`, `!=`, `<`, `>` | Compare |
| `&&`, `\|\|`, `!` | AND, OR, NOT |
| `contains` | Substring in a field or payload |
| `matches` | Regular expression |

## Command-line equivalent (tshark, not used in the lab)
```bash
tshark -r sample.pcap -Y "udp.port == 53"                       # apply a display filter
tshark -r sample.pcap -Y "dns" -T fields -e dns.qry.name        # print only query names
```
