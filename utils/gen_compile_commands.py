#!/usr/bin/env python3
"""
Generate compile_commands.json from GHS MULTI .gpj project files.
Run from the App directory (where default.gpj lives).

Usage:
    python3 tools/gen_compile_commands.py
    python3 tools/gen_compile_commands.py path/to/root.gpj
"""

import json
import os
import re
import sys
from pathlib import Path

SOURCE_EXTENSIONS = {'.cpp', '.c', '.cxx', '.cc'}

INTEGRITY_INCLUDE = Path('/home/monpbass/bmx/mcb_firmware/Bsp/INTEGRITY-include')

BASE_FLAGS = [
    '-std=c++14',
    f'-I{INTEGRITY_INCLUDE}',
    '-D__INTEGRITY',
    '-w',
]


def resolve_include(path_str, project_root, gpj_dir):
    """Resolve a -I path: try project root first, then gpj dir."""
    p = path_str.replace('\\', '/')
    for base in (project_root, gpj_dir):
        resolved = (base / p).resolve()
        if resolved.exists():
            return resolved
    # Return best guess even if it doesn't exist yet (generated headers)
    return (project_root / p).resolve()


def resolve_source(file_str, project_root, gpj_dir, source_dir):
    """
    Resolve a source file path.
    Files without a separator: look in source_dir.
    Files with a separator: try project_root, gpj_dir, source_dir, source_dir.parent.
    """
    p = file_str.replace('\\', '/')
    if '/' not in p:
        # Plain filename → sourceDir
        candidate = (source_dir / p).resolve()
        if candidate.exists():
            return candidate
        # Fallback: search from project root
        for found in project_root.rglob(p):
            return found
        return candidate

    # Path with separators: try several bases in order
    for base in (project_root, gpj_dir, source_dir, source_dir.parent):
        candidate = (base / p).resolve()
        if candidate.exists():
            return candidate

    return None  # not found


def parse_gpj(gpj_path, project_root, inherited_flags=None, visited=None):
    """
    Recursively parse a .gpj file.
    Returns a list of (Path, [flags]) for every source file found.
    """
    if visited is None:
        visited = set()
    if inherited_flags is None:
        inherited_flags = []

    gpj_path = Path(gpj_path).resolve()
    if gpj_path in visited or not gpj_path.exists():
        return []
    visited.add(gpj_path)

    gpj_dir = gpj_path.parent
    source_dir = gpj_dir
    local_flags = list(inherited_flags)
    entries = []

    with open(gpj_path, errors='replace') as f:
        lines = f.readlines()

    for line in lines:
        line = line.strip()
        if not line or line.startswith('#'):
            continue

        # Strip conditional prefixes: {config(...)}, {optgroup=...}, {isdefined(...)}
        line = re.sub(r'^\{[^}]+\}\s*', '', line)
        if not line:
            continue

        # Project type header [Program], [Library], etc.
        if re.match(r'^\[.+\]$', line):
            continue

        # :sourceDir=
        m = re.match(r'^:sourceDir=(.+)', line)
        if m:
            sd_str = m.group(1).replace('\\', '/')
            for base in (project_root, gpj_dir):
                candidate = (base / sd_str).resolve()
                if candidate.exists():
                    source_dir = candidate
                    break
            continue

        # Other directives starting with :
        if line.startswith(':'):
            continue

        # -I include paths
        if line.startswith('-I'):
            inc = resolve_include(line[2:], project_root, gpj_dir)
            local_flags.append(f'-I{inc}')
            continue

        # -D defines
        if line.startswith('-D'):
            local_flags.append(line)
            continue

        # GHS C++ standard flag: --c++17 → -std=c++17
        m = re.match(r'^--c\+\+(\w+)', line)
        if m:
            local_flags.append(f'-std=c++{m.group(1)}')
            continue

        # -std= passthrough
        if line.startswith('-std='):
            local_flags.append(line)
            continue

        # Subproject reference: foo.gpj [Type]
        m = re.match(r'^(.+\.gpj)\s+\[.+\]', line, re.IGNORECASE)
        if m:
            sub_str = m.group(1).replace('\\', '/')
            for base in (project_root, gpj_dir):
                sub_gpj = (base / sub_str).resolve()
                if sub_gpj.exists():
                    entries.extend(parse_gpj(sub_gpj, project_root, local_flags, visited))
                    break
            continue

        # Bare subproject: foo.gpj
        if re.match(r'^.+\.gpj$', line, re.IGNORECASE):
            sub_str = line.replace('\\', '/')
            for base in (project_root, gpj_dir):
                sub_gpj = (base / sub_str).resolve()
                if sub_gpj.exists():
                    entries.extend(parse_gpj(sub_gpj, project_root, local_flags, visited))
                    break
            continue

        # Source files
        if Path(line.replace('\\', '/')).suffix.lower() in SOURCE_EXTENSIONS:
            resolved = resolve_source(line, project_root, gpj_dir, source_dir)
            if resolved and resolved.exists():
                entries.append((resolved, list(local_flags)))

    return entries


def build_compile_commands(entries, project_root):
    commands = []
    seen = set()
    for src_path, flags in entries:
        if src_path in seen:
            continue
        seen.add(src_path)

        all_flags = BASE_FLAGS + flags
        # Deduplicate flags preserving order
        deduped = list(dict.fromkeys(all_flags))

        compiler = 'clang++' if src_path.suffix.lower() in {'.cpp', '.cxx', '.cc'} else 'clang'
        commands.append({
            'directory': str(project_root),
            'file': str(src_path),
            'command': ' '.join([compiler] + deduped + [str(src_path)]),
        })
    return commands


def main():
    if len(sys.argv) > 1:
        root_gpj = Path(sys.argv[1]).resolve()
    else:
        root_gpj = Path('default.gpj').resolve()

    project_root = root_gpj.parent

    if not root_gpj.exists():
        print(f'Error: {root_gpj} not found', file=sys.stderr)
        sys.exit(1)

    print(f'Parsing {root_gpj} ...')
    entries = parse_gpj(root_gpj, project_root)

    commands = build_compile_commands(entries, project_root)

    out_path = project_root / 'compile_commands.json'
    with open(out_path, 'w') as f:
        json.dump(commands, f, indent=2)

    print(f'Written {len(commands)} entries to {out_path}')


if __name__ == '__main__':
    main()
