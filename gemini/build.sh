#!/usr/bin/env bash
# Builds the Gemini upload package from the single source template.
# Usage: ./gemini/build.sh   ->  gemini/kos-finder-id.zip
# The Gemini SKILL.md is kept as SKILL.gemini.md so local agents that scan
# for SKILL.md recursively don't register a duplicate skill.
set -euo pipefail
cd "$(dirname "$0")"
python3 - <<'PY'
import zipfile
with zipfile.ZipFile("kos-finder-id.zip", "w", zipfile.ZIP_DEFLATED) as z:
    z.write("SKILL.gemini.md", "SKILL.md")
    z.write("../assets/template.html", "assets/template.html")
PY
echo "Built gemini/kos-finder-id.zip"
