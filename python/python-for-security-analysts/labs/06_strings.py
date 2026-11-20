# ==============================================================================
# Lab 06: Work with strings
# Scenario: update employee IDs, extract characters from a device ID, and
#           extract components from a URL.
# ==============================================================================

print("--- Task 1: convert an ID to a string (type(), str()) ---")
employee_id = 4186
print(type(employee_id))
employee_id = str(employee_id)
print(type(employee_id))

print("\n--- Task 2: check the length (len()) ---")
if len(employee_id) < 5:
    print("This employee ID has less than five digits. It does not meet length requirements.")

print("\n--- Task 3: concatenation to reach the five-character format ---")
employee_id = str(4186)
print(employee_id)
if len(employee_id) < 5:
    employee_id = "E" + employee_id
print(employee_id)

print("\n--- Task 4: indexing (fourth character; indexes start at 0) ---")
device_id = "r262c36"
print(device_id[3])

print("\n--- Task 5: slicing (first through third characters; end index excluded) ---")
print(device_id[0:3])

print("\n--- Task 6: slicing a URL (protocol + ://) ---")
url = "https://exampleURL1.com"
print(url[0:8])

print("\n--- Task 7: .index() finds where a substring starts ---")
print(url.index(".com"))

print("\n--- Task 8: store the index in a variable ---")
ind = url.index(".com")

print("\n--- Task 9: extract the domain extension ---")
print(url[ind:ind + 4])

print("\n--- Task 10: extract the website name ---")
print(url[8:ind])
