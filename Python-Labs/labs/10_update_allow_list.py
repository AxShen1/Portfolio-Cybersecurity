# ==============================================================================
# Lab 10: Create another algorithm
# Scenario: parse a file of IP addresses that may access restricted content and
#           update it by removing the addresses that no longer have access.
# Works on a temporary sample file (the lab's own allow_list.txt is not included).
# ==============================================================================
import tempfile
from pathlib import Path


def update_file(import_file, remove_list):
    """Lab version (Task 9): read the file, remove addresses, rewrite the file."""
    with open(import_file, "r") as file:
        ip_addresses = file.read()          # string
    ip_addresses = ip_addresses.split()     # list
    for element in ip_addresses:
        if element in remove_list:
            ip_addresses.remove(element)
    ip_addresses = " ".join(ip_addresses)   # back to a string
    with open(import_file, "w") as file:
        file.write(ip_addresses)


def update_file_safe(import_file, remove_list):
    """Same algorithm, but loops over remove_list instead of the list being edited."""
    with open(import_file, "r") as file:
        ip_addresses = file.read().split()
    for element in remove_list:
        if element in ip_addresses:
            ip_addresses.remove(element)
    with open(import_file, "w") as file:
        file.write(" ".join(ip_addresses))


SAMPLE_ALLOW_LIST = (
    "192.168.97.225 192.168.25.60 192.168.205.12 192.168.158.170 192.168.6.9 "
    "192.168.52.90 192.168.201.40 192.168.90.124 192.168.186.176 192.168.140.81 "
    "192.168.133.188 192.168.203.198 192.168.58.57 192.168.218.219"
)

with tempfile.TemporaryDirectory() as tmp:
    import_file = str(Path(tmp) / "allow_list.txt")
    Path(import_file).write_text(SAMPLE_ALLOW_LIST)

    print("--- Tasks 1-3: the file and the remove list ---")
    remove_list = ["192.168.97.225", "192.168.158.170", "192.168.201.40", "192.168.58.57"]
    print(import_file.split("/")[-1])
    print(remove_list)
    print(Path(import_file).read_text())

    print("\n--- Tasks 4-8: split, loop, remove, rewrite, verify ---")
    ip_addresses = Path(import_file).read_text().split()
    print(ip_addresses)
    for element in ip_addresses:
        if element in remove_list:
            ip_addresses.remove(element)
    print(ip_addresses)

    print("\n--- Tasks 9-10: the algorithm as a function, applied to a second remove list ---")
    update_file(import_file, remove_list)
    update_file(import_file, ["192.168.25.60", "192.168.140.81", "192.168.203.198"])
    print(Path(import_file).read_text())

# ------------------------------------------------------------------------------
# Extension (not part of the lab): a pitfall of removing from a list while looping
# ------------------------------------------------------------------------------
print("\n--- Extension: removing items while looping over the same list ---")
with tempfile.TemporaryDirectory() as tmp:
    f = str(Path(tmp) / "list.txt")
    to_remove = ["10.0.0.1", "10.0.0.2"]            # two removable entries next to each other

    Path(f).write_text("10.0.0.1 10.0.0.2 10.0.0.3")
    update_file(f, to_remove)
    print("lab version  :", Path(f).read_text())    # 10.0.0.2 is skipped and stays

    Path(f).write_text("10.0.0.1 10.0.0.2 10.0.0.3")
    update_file_safe(f, to_remove)
    print("safe version :", Path(f).read_text())
