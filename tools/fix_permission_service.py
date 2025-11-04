#!/usr/bin/env python3
"""
Fix hardcoded Korean text in permission_service.dart
"""

import os

def main():
    """Main function"""
    # Get the script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)

    # Define file path
    file_path = os.path.join(project_root, 'lib', 'services', 'auth', 'permission_service.dart')

    # Read the file
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Replace the hardcoded Korean text
    old_text = "Text('• 데이터 복원', style: TextStyle(fontSize: 14))"
    new_text = "Text(AppLocalizations.of(context)!.dataRestore, style: TextStyle(fontSize: 14))"

    content = content.replace(old_text, new_text)

    # Write back the file
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

    print("Fixed hardcoded Korean text in permission_service.dart")

if __name__ == '__main__':
    main()
