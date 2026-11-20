# ==============================================================================
# Lab 05: Built-in functions (sorted, max) and functions with parameters / return
# Scenario: look for outliers in monthly failed logins, then compare a user's
#           logins today with their daily average.
# ==============================================================================

# Failed login attempts per month (January ... December)
failed_login_list = [119, 101, 99, 91, 92, 105, 108, 85, 88, 90, 264, 223]

print("--- Task 1: sorted() ---")
print(sorted(failed_login_list))
# The last two values (223 and 264) stand out from the rest.

print("\n--- Task 2: max() ---")
print(max(failed_login_list))

print("\n--- Tasks 3-4: analyze_logins() with two parameters ---")
def analyze_logins(username, current_day_logins):
    print("Current day login total for", username, "is", current_day_logins)

analyze_logins("ejones", 9)

print("\n--- Task 5: third parameter (average) ---")
def analyze_logins(username, current_day_logins, average_day_logins):
    print("Current day login total for", username, "is", current_day_logins)
    print("Average logins per day for", username, "is", average_day_logins)

analyze_logins("ejones", 9, 3)

print("\n--- Task 6: login ratio ---")
def analyze_logins(username, current_day_logins, average_day_logins):
    print("Current day login total for", username, "is", current_day_logins)
    print("Average logins per day for", username, "is", average_day_logins)
    login_ratio = current_day_logins / average_day_logins
    print(username, "logged in", login_ratio, "times as much as they do on an average day.")

analyze_logins("ejones", 9, 3)

print("\n--- Task 7: return the ratio instead of printing it ---")
def analyze_logins(username, current_day_logins, average_day_logins):
    print("Current day login total for", username, "is", current_day_logins)
    print("Average logins per day for", username, "is", average_day_logins)
    login_ratio = current_day_logins / average_day_logins
    return login_ratio

login_analysis = analyze_logins("ejones", 9, 3)
print("ejones", "logged in", login_analysis, "times as much as they do on an average day.")

print("\n--- Task 8: use the returned value in a conditional (alert threshold) ---")
login_analysis = analyze_logins("ejones", 9, 3)
if login_analysis >= 3:
    print("Alert! This account has more login activity than normal.")
# Note: the lab assumes average_day_logins > 0. A value of 0 would raise
# ZeroDivisionError, so real code would check for that first.
