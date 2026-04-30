#!/usr/bin/env python3
"""Deduplicate ARB files: keep the LAST occurrence of each key."""

import json
import os
import re
import sys

L10N_DIR = os.path.join(os.path.dirname(__file__), '..', 'lib', 'l10n')

def deduplicate_arb(path):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Parse all key-value pairs, keeping track of order
    # We need to handle the full JSON with potential duplicates
    data = json.loads(content)
    
    # Remove duplicate keys by re-parsing and keeping last
    lines = content.split('\n')
    seen_keys = {}
    result_lines = []
    
    for line in lines:
        m = re.match(r'^\s+"([^"]+)"\s*:', line)
        if m:
            key = m.group(1)
            if key in seen_keys:
                # Remove the previous occurrence
                pass
            seen_keys[key] = line
    
    # Write back with proper JSON to remove duplicates
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write('\n')

if __name__ == '__main__':
    path = os.path.join(L10N_DIR, 'app_en.arb')
    # Simply load and save to deduplicate
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write('\n')
    print(f'Deduplicated {path}: {len(data)} unique keys')
