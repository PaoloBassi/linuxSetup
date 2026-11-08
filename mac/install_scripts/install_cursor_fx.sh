#!/bin/bash

source "$(dirname "$0")/declarations.sh"

# animated cursor shaders for Ghostty (needs Ghostty >= 1.4 and the ghostty config already linked)
CURSOR_FX_DIR="$HOME/.local/share/ghostty-cursor-fx"
CURSOR_FX_EFFECT="lightning"

if [ -d "$CURSOR_FX_DIR/.git" ]; then
    run_silent "Update ghostty-cursor-fx" git -C "$CURSOR_FX_DIR" pull --ff-only
else
    run_silent "Clone ghostty-cursor-fx" git clone https://github.com/Avarce/ghostty-cursor-fx.git "$CURSOR_FX_DIR"
fi

# install.sh follows the config symlink: shaders/ and cursor-effects/ land in $FILES_DIR/ghostty (gitignored)
run_silent "Install cursor-fx" "$CURSOR_FX_DIR/install.sh"

# Ghostty resolves config-file paths from ~/.config/ghostty (the symlink), not from the repo
link "$FILES_DIR/ghostty/shaders" "$HOME/.config/ghostty/shaders"
link "$FILES_DIR/ghostty/cursor-effects" "$HOME/.config/ghostty/cursor-effects"

# keep the effect already chosen in the tracked config, pick the default only on a fresh one
grep -q '^config-file = cursor-effects/' "$FILES_DIR/ghostty/config" || \
    run_silent "Enable $CURSOR_FX_EFFECT cursor effect" "$HOME/.local/bin/cursor-fx" "$CURSOR_FX_EFFECT"

# Enter/done signals: merge the repo's UserPromptSubmit/Stop hooks into Claude Code settings (idempotent)
run_silent "Add cursor-fx hooks to Claude Code" python3 - "$CURSOR_FX_DIR/hooks/claude-code-hook.json" "$HOME/.claude/settings.json" <<'EOF'
import json, os, sys

src, dst = sys.argv[1], sys.argv[2]
with open(src) as f:
    new = json.load(f)["hooks"]
settings = {}
if os.path.exists(dst):
    with open(dst) as f:
        settings = json.load(f)

hooks = settings.setdefault("hooks", {})
for event, groups in new.items():
    current = hooks.setdefault(event, [])
    present = {h.get("command") for g in current for h in g.get("hooks", [])}
    for group in groups:
        if not any(h.get("command") in present for h in group["hooks"]):
            current.append(group)

os.makedirs(os.path.dirname(dst), exist_ok=True)
with open(dst, "w") as f:
    json.dump(settings, f, indent=2)
    f.write("\n")
EOF

exit $error_counter
