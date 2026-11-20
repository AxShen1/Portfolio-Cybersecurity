# ==============================================================================
# Lab 08: Regular expressions (re module)
# Scenario: find devices that need an OS update (IDs starting with "r15") and
#           extract IP addresses from a login log, then compare them to a list
#           of flagged addresses.
# ==============================================================================
import re

print("--- Tasks 2-4: device IDs starting with 'r15' ---")
devices = "r262c36 67bv8fy 41j1u2e r151dm4 1270t3o 42dr56i r15xk9h 2j33krk 253be78 ac742a1 r15u9q5 zh86b2l ii286fq 9x482kt 6oa6m6u x3463ac i4l56nq g07h55q 081qc9t r159r1u"
# r15 = the literal characters, \w = any alphanumeric character, + = one or more
target_pattern = r"r15\w+"
print(re.findall(target_pattern, devices))

# Login log: username, date, time, IP address (some IP addresses are malformed)
log_file = "eraab 2022-05-10 6:03:41 192.168.152.148 \niuduike 2022-05-09 6:46:40 192.168.22.115 \nsmartell 2022-05-09 19:30:32 192.168.190.178 \narutley 2022-05-12 17:00:59 1923.1689.3.24 \nrjensen 2022-05-11 0:59:26 192.168.213.128 \naestrada 2022-05-09 19:28:12 1924.1680.27.57 \nasundara 2022-05-11 18:38:07 192.168.96.200 \ndkot 2022-05-12 10:52:00 1921.168.1283.75 \nabernard 2022-05-12 23:38:46 19245.168.2345.49 \ncjackson 2022-05-12 19:36:42 192.168.247.153 \njclark 2022-05-10 10:48:02 192.168.174.117 \nalevitsk 2022-05-08 12:09:10 192.16874.1390.176 \njrafael 2022-05-10 22:40:01 192.168.148.115 \nyappiah 2022-05-12 10:37:22 192.168.103.10654 \ndaquino 2022-05-08 7:02:35 192.168.168.144"

print("\n--- Task 5: the log ---")
print(log_file)

print("\n--- Tasks 6-7: exactly three digits per segment (\\d\\d\\d\\.) ---")
pattern = r"\d\d\d\.\d\d\d\.\d\d\d\.\d\d\d"
print(re.findall(pattern, log_file))
# Misses valid addresses such as 192.168.22.115 (segments with fewer digits)

print("\n--- Task 8: one or more digits per segment (\\d+) ---")
pattern = r"\d+\.\d+\.\d+\.\d+"
print(re.findall(pattern, log_file))
# Now it also matches malformed addresses such as 1923.1689.3.24

print("\n--- Task 9: one to three digits per segment (\\d{1,3}) ---")
pattern = r"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"
valid_ip_addresses = re.findall(pattern, log_file)
print(valid_ip_addresses)

print("\n--- Tasks 10-11: compare with flagged addresses ---")
flagged_addresses = ["192.168.190.178", "192.168.96.200", "192.168.174.117", "192.168.168.144"]
print(flagged_addresses)
for address in valid_ip_addresses:
    if address in flagged_addresses:
        print("The IP address", address, "has been flagged for further analysis.")
    else:
        print("The IP address", address, "does not require further analysis.")

# ------------------------------------------------------------------------------
# Extension (not part of the lab): a stricter pattern
# ------------------------------------------------------------------------------
# Observation: the Task 9 pattern returns 192.168.103.106, but the log contains
# 192.168.103.10654. That address is malformed, and the pattern only matched its
# first 106. Word boundaries (\b) make the whole token match or not at all.
print("\n--- Extension: word boundaries ---")
strict_pattern = r"\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b"
strict_matches = re.findall(strict_pattern, log_file)
print(strict_matches)
print("Partial match removed:", set(valid_ip_addresses) - set(strict_matches))
