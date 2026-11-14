# ==============================================================================
# Lab 09: Import and parse a text file
# Scenario: prepare a security log for analysis and create a text file with the
#           IP addresses that are allowed to access restricted information.
# The script works on a temporary copy of data/login.txt, so the repository's
# data file stays unchanged however many times you run it.
# ==============================================================================
import shutil
import tempfile
from pathlib import Path

source = Path(__file__).resolve().parent.parent / "data" / "login.txt"

with tempfile.TemporaryDirectory() as tmp:
    import_file = str(Path(tmp) / "login.txt")
    shutil.copy(source, import_file)

    print("--- Tasks 1-2: open() with a `with` statement and .read() ---")
    with open(import_file, "r") as file:
        text = file.read()
    print(text)

    print("--- Task 3: .split() turns the string into a list ---")
    # split() with no argument splits on whitespace, i.e. one element per log line
    print(text.split())

    print("\n--- Task 4: append a missing entry (mode \"a\") ---")
    missing_entry = "jrafael,192.168.243.140,4:56:27,2022-05-09"
    with open(import_file, "a") as file:
        file.write(missing_entry)
    with open(import_file, "r") as file:
        text = file.read()
    print(text)

    print("\n--- Tasks 5-7: create an allow list file (mode \"w\") and read it back ---")
    allow_file = str(Path(tmp) / "allow_list.txt")
    ip_addresses = "192.168.218.160 192.168.97.225 192.168.145.158 192.168.108.13 192.168.60.153 192.168.96.200 192.168.247.153 192.168.3.252 192.168.116.187 192.168.15.110 192.168.39.246"
    print(allow_file.split("/")[-1])
    print(ip_addresses)
    with open(allow_file, "w") as file:
        file.write(ip_addresses)
    with open(allow_file, "r") as file:
        text = file.read()
    print(text)
