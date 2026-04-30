#!/usr/bin/env python3
"""Copy missing keys from app_en.arb to other locale files."""

import json
import os
import sys

L10N_DIR = os.path.join(os.path.dirname(__file__), '..', 'lib', 'l10n')

def load_arb(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def save_arb(data, path):
    # Write with trailing newline
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write('\n')

def main():
    en = load_arb(os.path.join(L10N_DIR, 'app_en.arb'))
    
    locales = ['de', 'es', 'fr', 'ja', 'ko', 'pt', 'ru', 'zh', 'zh_TW']
    
    for locale in locales:
        path = os.path.join(L10N_DIR, f'app_{locale}.arb')
        if not os.path.exists(path):
            print(f'Skipping {locale}: file not found')
            continue
        
        data = load_arb(path)
        added = 0
        for key, value in en.items():
            if key not in data:
                data[key] = value
                added += 1
        
        if added > 0:
            save_arb(data, path)
            print(f'{locale}: added {added} keys')
        else:
            print(f'{locale}: up to date')

if __name__ == '__main__':
    main()
