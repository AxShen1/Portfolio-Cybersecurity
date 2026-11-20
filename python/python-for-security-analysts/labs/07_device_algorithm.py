# ==============================================================================
# Lab 07: Develop an algorithm
# Scenario: connect users to their assigned devices. Check that a user is
#           approved and that the device they brought is the one assigned to them.
# ==============================================================================

# Two synchronized lists: the user at index N uses the device at index N
approved_users = ["elarson", "bmoreno", "tshah", "sgilmore", "eraab"]
approved_devices = ["8rp2k75", "hl0s5o1", "2ye3lzg", "4n482ts", "a307vir"]

print("--- Task 1: indexing lists ---")
print(approved_users[0])
print(approved_devices[0])

print("\n--- Task 2: add a new user and device (.append()) ---")
new_user = "gesparza"
new_device = "3rcv4w6"
approved_users.append(new_user)
approved_devices.append(new_device)
print(approved_users)
print(approved_devices)

print("\n--- Task 3: remove a user and device (.remove()) ---")
removed_user = "tshah"
removed_device = "2ye3lzg"
approved_users.remove(removed_user)
approved_devices.remove(removed_device)
print(approved_users)
print(approved_devices)

print("\n--- Task 4: is the user approved? ---")
username = "sgilmore"
if username in approved_users:
    print("The username", username, "is approved to access the system.")
else:
    print("The username", username, "is not approved to access the system.")

print("\n--- Task 5: position of the user in the list (.index()) ---")
ind = approved_users.index(username)
print(ind)

print("\n--- Task 6: use that position to find the matching device ---")
print(approved_devices[ind])

print("\n--- Task 7: user approved AND device matches ---")
device_id = "4n482ts"
if username in approved_users and device_id == approved_devices[ind]:
    print("The username", username, "is approved to access the system.")
    print(device_id, "is the assigned device for", username)

print("\n--- Task 8: approved user, wrong device (elif) ---")
for device_id in ["4n482ts", "r2s5r9g"]:
    if username in approved_users and device_id == approved_devices[ind]:
        print("The user", username, "is approved to access the system.")
        print(device_id, "is the assigned device for", username)
    elif username in approved_users and device_id != approved_devices[ind]:
        print("The user", username, "is approved to access the system, but", device_id, "is not their assigned device.")

print("\n--- Task 9: the complete algorithm as a function (nested conditionals) ---")
def login(username, device_id):
    # Outer conditional: is the username approved?
    if username in approved_users:
        print("The user", username, "is approved to access the system.")
        ind = approved_users.index(username)
        # Inner conditional: is this the assigned device?
        if device_id == approved_devices[ind]:
            print(device_id, "is the assigned device for", username)
        else:
            print(device_id, "is not their assigned device.")
    else:
        print("The username", username, "is not approved to access the system.")

login("bmoreno", "hl0s5o1")
login("elarson", "r2s5r9g")
login("abernard", "4n482ts")
