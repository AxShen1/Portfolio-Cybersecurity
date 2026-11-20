# 📖 tcpdump Command Reference

## Used in this lab
| Command | Purpose |
|---|---|
| `sudo ifconfig` | Show network interfaces and addresses |
| `sudo tcpdump -D` | List interfaces available for capture |
| `sudo tcpdump -i eth0 -v -c5` | 5 packets live from `eth0`, verbose |
| `sudo tcpdump -c3 -i any -v` | 3 packets from any interface, verbose |
| `sudo tcpdump -i eth0 -nn -c9 port 80 -w capture.pcap &` | Capture 9 HTTP packets to a file, in the background |
| `sudo tcpdump -nn -r capture.pcap -v` | Read a capture file, verbose headers |
| `sudo tcpdump -nn -r capture.pcap -X` | Read a capture file, hex + ASCII |

## Options
| Option | Meaning |
|---|---|
| `-i <iface>` | Interface (`any` = all) |
| `-D` | List interfaces |
| `-c <n>` | Stop after n packets |
| `-n` / `-nn` | No name resolution for hosts / for hosts and ports |
| `-v` | Verbose (more IP header details) |
| `-X` | Hex and ASCII dump of packet data |
| `-w <file>` | Write raw packets to a file |
| `-r <file>` | Read packets from a file |

## Capture filters (add after the options)
| Filter | Matches |
|---|---|
| `port 80` | Source or destination port 80 |
| `tcp`, `udp`, `icmp` | By protocol |

## Additional options and filters (not part of the lab)
| Command | Purpose |
|---|---|
| `host 10.0.0.5` | Traffic to or from one host |
| `src host 10.0.0.5` / `dst host 10.0.0.5` | By direction |
| `port 53 and udp` | Combine with `and`, `or`, `not` |
| `-s 0` | Capture full packets (not truncated) |
| `-A` | Print payload as ASCII only |
| `-tttt` | Human-readable date and time stamps |
| `-C 10 -W 5 -w cap.pcap` | Rotate files (10 MB each, keep 5) for long captures |

## Reading TCP flags in output
| Shown as | Meaning |
|---|---|
| `[S]` | SYN (connection request) |
| `[S.]` | SYN-ACK |
| `[.]` | ACK |
| `[P.]` | PSH-ACK (data being pushed) |
| `[F.]` | FIN-ACK (closing) |
| `[R]` | RST (reset) |

## Tips
- Capturing usually requires `sudo`.
- Press `Ctrl+C` to stop a capture that has no `-c` limit.
- Open a saved `.pcap` in Wireshark for a graphical view.
