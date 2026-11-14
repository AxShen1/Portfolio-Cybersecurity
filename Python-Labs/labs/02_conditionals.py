# ==============================================================================
# Lab 02: Conditional statements (if / elif / else, and, or, in)
# Scenario: check whether a system needs an update, then check whether a login
#           attempt was made by an approved user during organization hours.
# ==============================================================================

print("--- Task 1: `if` ---")
system = "OS 2"
# If OS 2 is running, then display a "no update needed" message
if system == "OS 2":
    print("no update needed")

print("\n--- Task 2: `if` with a value that does not match (OS 1) ---")
system = "OS 1"
if system == "OS 2":
    print("no update needed")
# Nothing is printed: the condition is False and there is no alternative branch.

print("\n--- Task 3: `if` / `else` ---")
for system in ["OS 2", "OS 1", "OS 3"]:
    if system == "OS 2":
        print(system, "->", "no update needed")
    else:
        print(system, "->", "update needed")

print("\n--- Task 4: `if` / `elif` / `elif` ---")
for system in ["OS 2", "OS 1", "OS 3", "OS 4"]:
    if system == "OS 2":
        print(system, "->", "no update needed")
    elif system == "OS 1":
        print(system, "->", "update needed")
    elif system == "OS 3":
        print(system, "->", "update needed")
    # "OS 4" matches nothing and produces no output (there is no final `else`).

print("\n--- Task 5: the two `elif` branches combined with `or` ---")
for system in ["OS 2", "OS 1", "OS 3", "OS 4"]:
    if system == "OS 2":
        print(system, "->", "no update needed")
    elif system == "OS 1" or system == "OS 3":
        print(system, "->", "update needed")

print("\n--- Task 6: two approved users compared with `or` ---")
approved_user1 = "elarson"
approved_user2 = "bmoreno"
username = "bmoreno"
if username == approved_user1 or username == approved_user2:
    print("This user has access to this device.")
else:
    print("This user does not have access to this device.")

print("\n--- Task 7: allow list and the `in` operator ---")
approved_list = ["elarson", "bmoreno", "tshah", "sgilmore", "eraab"]
for username in ["bmoreno", "abernard"]:
    if username in approved_list:
        print(username, "->", "This user has access to this device.")
    else:
        print(username, "->", "This user does not have access to this device.")

print("\n--- Task 8: Boolean condition (organization hours) ---")
for organization_hours in [True, False]:
    if organization_hours == True:
        print("Login attempt made during organization hours.")
    else:
        print("Login attempt made outside of organization hours.")

print("\n--- Task 9: both checks, as two independent conditionals ---")
username = "bmoreno"
organization_hours = True
if username in approved_list:
    print("This user has access to this device.")
else:
    print("This user does not have access to this device.")
if organization_hours == True:
    print("Login attempt made during organization hours.")
else:
    print("Login attempt made outside of organization hours.")

print("\n--- Task 10: both checks combined with `and` (single message) ---")
for username, organization_hours in [("bmoreno", True), ("bmoreno", False), ("abernard", True)]:
    if username in approved_list and organization_hours == True:
        print(username, organization_hours, "->", "Login attempt made by an approved user during organization hours.")
    else:
        print(username, organization_hours, "->", "Username not approved or login attempt made outside of organization hours.")
