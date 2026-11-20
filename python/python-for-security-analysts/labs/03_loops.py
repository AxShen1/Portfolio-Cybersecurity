# ==============================================================================
# Lab 03: Loops (for, while, range(), break)
# Scenario: repeat connection messages, check IP addresses against an allow
#           list, and generate employee IDs for the Sales department.
# ==============================================================================

print("--- Task 1: `for` + range() ---")
for i in range(3):
    print("Connection could not be established.")

print("\n--- Task 2: range() with a variable ---")
connection_attempts = 3
for i in range(connection_attempts):
    print("Connection could not be established.")

print("\n--- Task 3: the same result with `while` ---")
connection_attempts = 0
while connection_attempts < 3:
    print("Connection could not be established.")
    # Without this increment the loop would never end
    connection_attempts = connection_attempts + 1

print("\n--- Task 4: iterate over a list of IP addresses ---")
ip_addresses = ["192.168.142.245", "192.168.109.50", "192.168.86.232", "192.168.131.147",
                "192.168.205.12", "192.168.200.48"]
for i in ip_addresses:
    print(i)

# NOTE: the lab provides `allow_list` in its own cell. The list below is a sample
# I use so that the script runs on its own (192.168.200.48 is deliberately missing).
allow_list = ["192.168.142.245", "192.168.109.50", "192.168.86.232",
              "192.168.131.147", "192.168.205.12"]

print("\n--- Task 5: `if` inside the loop (allow list check) ---")
for i in ip_addresses:
    if i in allow_list:
        print("IP address is allowed")
    else:
        print("IP address is not allowed")

print("\n--- Task 6: stop at the first IP that is not allowed (`break`) ---")
for i in ip_addresses:
    if i in allow_list:
        print("IP address is allowed")
    else:
        print("IP address is not allowed. Further investigation of login activity required")
        break

print("\n--- Task 7: `while` loop generating employee IDs (5000-5150, step 5) ---")
i = 5000
while i <= 5150:
    print(i)
    i = i + 5

print("\n--- Task 8: warning when the loop variable reaches 5100 ---")
i = 5000
while i <= 5150:
    print(i)
    if i == 5100:
        print("Only 10 valid employee ids remaining")
    i = i + 5
