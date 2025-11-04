#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Batch fix unnecessary_non_null_assertion warnings
Replaces AppLocalizations.of(context)! with AppLocalizations.of(context)
"""

import re
import sys
from pathlib import Path

# Windows encoding fix
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

files_to_fix = [
    'lib/screens/recovery/chad_active_recovery_screen.dart',
    'lib/services/core/deep_link_handler.dart',
    'lib/screens/subscription/subscription_screen.dart',
    'lib/widgets/subscription/no_subscription_view.dart',
    'lib/screens/subscription/signup_for_purchase_screen.dart',
    'lib/widgets/pushup_form_guide/form_steps_tab.dart',
    'lib/screens/scientific_evidence/scientific_evidence_screen.dart',
]

def fix_file(file_path):
    """Remove unnecessary ! from AppLocalizations.of(context)!"""
    path = Path(file_path)
    if not path.exists():
        print(f"⚠️  File not found: {file_path}")
        return 0

    content = path.read_text(encoding='utf-8')
    original_content = content

    # Replace AppLocalizations.of(context)! with AppLocalizations.of(context)
    content = re.sub(
        r'AppLocalizations\.of\(context\)!',
        r'AppLocalizations.of(context)',
        content
    )

    if content != original_content:
        path.write_text(content, encoding='utf-8')
        count = original_content.count('AppLocalizations.of(context)!') - content.count('AppLocalizations.of(context)!')
        print(f"✓ {file_path}: {count} replacements")
        return count
    else:
        print(f"  {file_path}: No changes needed")
        return 0

def main():
    print("="*60)
    print("Fixing unnecessary_non_null_assertion warnings")
    print("="*60)

    total = 0
    for file_path in files_to_fix:
        count = fix_file(file_path)
        total += count

    print("="*60)
    print(f"Total: {total} replacements")
    print("="*60)

if __name__ == '__main__':
    main()
