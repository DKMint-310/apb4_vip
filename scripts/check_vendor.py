"""Check the fixed third-party snapshot, without network access or dependencies."""
import hashlib
import json
from pathlib import Path
import sys

root = Path(__file__).resolve().parents[1]
vendor = root / 'third_party'
manifest = json.loads((vendor / 'manifest.json').read_text(encoding='utf-8'))
failures = []
checked = 0
for dependency in manifest['dependencies']:
    dependency_root = (vendor / dependency['name']).resolve()
    if not dependency_root.is_relative_to(vendor.resolve()):
        failures.append(f"Invalid dependency path: {dependency['name']}")
        continue
    expected_paths = set()
    for record in dependency['files']:
        target = (dependency_root / record['path']).resolve()
        if not target.is_relative_to(dependency_root):
            failures.append(f"Invalid source path: {record['path']}")
            continue
        expected_paths.add(target)
        if not target.is_file():
            failures.append(f'Missing: {target.relative_to(root)}')
        elif hashlib.sha256(target.read_bytes()).hexdigest() != record['sha256']:
            failures.append(f'Modified: {target.relative_to(root)}')
        checked += 1
    for target in dependency_root.rglob('*'):
        if target.is_file() and target.resolve() not in expected_paths:
            failures.append(f'Untracked upstream file: {target.relative_to(root)}')
if failures:
    print('\n'.join(failures), file=sys.stderr)
    sys.exit(1)
print(f'PASS: {checked} vendor files match pinned SHA-256 manifest.')
