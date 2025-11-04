#!/usr/bin/env python3
"""
Fix moreActivities code to use method instead of replaceAll
"""

import os

def main():
    """Main function"""
    # Get the script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)

    # Define file path
    file_path = os.path.join(project_root, 'lib', 'screens', 'recovery', 'chad_active_recovery_screen.dart')

    # Read the file
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Replace the problematic line
    old_code = "AppLocalizations.of(context)!.moreActivities.replaceAll('{count}', '${tomorrowActivities.length - 2}')"
    new_code = "AppLocalizations.of(context)!.moreActivities('${tomorrowActivities.length - 2}')"

    content = content.replace(old_code, new_code)

    # Write back the file
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

    print("Fixed moreActivities in chad_active_recovery_screen.dart")

if __name__ == '__main__':
    main()
