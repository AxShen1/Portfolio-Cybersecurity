# ==============================================================================
# Lab 04: Define and call a function
# Scenario: an alert() function, and a function that turns a list of approved
#           usernames into one string.
# ==============================================================================

print("--- Tasks 1-2: define and call alert() ---")
def alert():
    print("Potential security issue. Investigate further.")

alert()

print("\n--- Task 3: alert() with a for loop inside ---")
def alert():
    for i in range(3):
        print("Potential security issue. Investigate further.")

alert()

print("\n--- Tasks 4-5: list_to_string() displaying each element ---")
def list_to_string():
    username_list = ["elarson", "bmoreno", "tshah", "sgilmore", "eraab", "gesparza", "alevitsk", "wjaffrey"]
    for i in username_list:
        print(i)

list_to_string()

print("\n--- Task 6: string concatenation (usernames run together) ---")
def list_to_string():
    username_list = ["elarson", "bmoreno", "tshah", "sgilmore", "eraab", "gesparza", "alevitsk", "wjaffrey"]
    sum_variable = ""
    for i in username_list:
        sum_variable = sum_variable + i
    print(sum_variable)

list_to_string()

print("\n--- Task 7: add a comma and a space after each username ---")
def list_to_string():
    username_list = ["elarson", "bmoreno", "tshah", "sgilmore", "eraab", "gesparza", "alevitsk", "wjaffrey"]
    sum_variable = ""
    for i in username_list:
        sum_variable = sum_variable + i + ", "
    print(sum_variable)

list_to_string()
# Side note: this version leaves a trailing ", " after the last name.
# ", ".join(username_list) avoids that (covered in lab 10).
