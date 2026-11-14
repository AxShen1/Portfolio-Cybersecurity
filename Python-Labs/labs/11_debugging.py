# ==============================================================================
# Lab 11: Debug Python code
# Each task starts with a code sample that contained a bug. The comment names
# the error type and the fix; the code below is the corrected version.
#   - Syntax errors:  Python cannot parse the code (SyntaxError, IndentationError)
#   - Exceptions:     the code is valid but fails while running (NameError, IndexError, ...)
#   - Logic errors:   the code runs but gives a wrong result
# ==============================================================================
import tempfile
from pathlib import Path

print("--- Task 1: SyntaxError ---")
# Bug:  for i in range(10)        <- missing colon at the end of the loop header
for i in range(3):
    print("Connection cannot be established")

print("\n--- Task 2: SyntaxError ---")
# Bug:  ... "tbailey", "zdutchma, "esmith", ...   <- missing closing quote and comma
usernames_list = ["djames", "jpark", "tbailey", "zdutchma", "esmith", "srobinso", "dcoleman", "fbautist"]
print(usernames_list)

print("\n--- Task 3: SyntaxError ---")
# Bug:  print("update needed".upper()   <- missing closing parenthesis
print("update needed".upper())

print("\n--- Task 4: NameError, SyntaxError, IndentationError ---")
# Bugs: 1) `username_list` instead of `usernames_list`        -> NameError
#       2) `if name = username:` (assignment, not comparison)  -> SyntaxError
#       3) print() not indented under the `if`                 -> IndentationError
username = "esmith"
for name in usernames_list:
    if name == username:
        print("The user is an approved user")

print("\n--- Task 5: IndexError ---")
# Bug:  usernames_list[5] on a list with 5 elements. Valid indexes are 0-4.
usernames_list = ["elarson", "bmoreno", "tshah", "sgilmore", "eraab"]
username = "eraab"
if username == usernames_list[4]:
    print("This username is the final one in the list.")

print("\n--- Task 6: SyntaxError, then NameError ---")
# Bugs: 1) `with open(import_file, "r") as file`   <- missing colon
#       2) `split.ip_addresses()`                  <- NameError (`split` is not a variable); a string method is called on the string: ip_addresses.split()
with tempfile.TemporaryDirectory() as tmp:
    import_file = str(Path(tmp) / "allow_list.txt")
    Path(import_file).write_text("192.168.97.225 192.168.25.60 192.168.158.170 192.168.205.12")
    remove_list = ["192.168.97.225", "192.168.158.170", "192.168.201.40", "192.168.58.57"]

    with open(import_file, "r") as file:
        ip_addresses = file.read()
    ip_addresses = ip_addresses.split()
    for element in remove_list:
        if element in ip_addresses:
            ip_addresses.remove(element)
    print(ip_addresses)

print("\n--- Task 7: logic error ---")
# Bug:  the code ran without errors but printed the wrong patch date, because the
#       indexes did not match the order of `patch_schedule` (OS 1 -> 0, OS 2 -> 1, OS 3 -> 2).
patch_schedule = ["March 1st", "April 1st", "May 1st"]
for system in ["OS 1", "OS 2", "OS 3"]:
    if system == "OS 1":
        print(system, "-> Patch date:", patch_schedule[0])
    elif system == "OS 2":
        print(system, "-> Patch date:", patch_schedule[1])
    elif system == "OS 3":
        print(system, "-> Patch date:", patch_schedule[2])
