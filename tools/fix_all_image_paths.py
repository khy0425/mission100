#!/usr/bin/env python3
"""
Fix all wrong image paths in the project
"""

import os
import glob

def fix_file(file_path):
    """Fix image paths in a single file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        original_content = content

        # Replace the wrong image path
        content = content.replace("'assets/images/기본차드.jpg'", "'assets/images/chad/basic/basicChad.png'")
        content = content.replace('"assets/images/기본차드.jpg"', '"assets/images/chad/basic/basicChad.png"')

        # Only write if content changed
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
        return False
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

def main():
    """Main function"""
    # Get the script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)

    # Find all Dart files
    dart_files = glob.glob(os.path.join(project_root, 'lib', '**', '*.dart'), recursive=True)

    # Exclude archive files
    dart_files = [f for f in dart_files if 'archive' not in f.lower()]

    fixed_count = 0
    for file_path in dart_files:
        if fix_file(file_path):
            fixed_count += 1
            # Get relative path for display
            rel_path = os.path.relpath(file_path, project_root)
            print(f"Fixed: {rel_path}")

    print(f"\n✅ Fixed {fixed_count} files")
    print("Changed: 'assets/images/기본차드.jpg' → 'assets/images/chad/basic/basicChad.png'")

if __name__ == '__main__':
    main()
