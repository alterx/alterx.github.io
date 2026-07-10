#!/usr/bin/env bash
#
# Regenerate the downloadable CV PDFs (English + Spanish) from index.html.
# Run this whenever you change the CV content.
#
# Produces clean, ATS-friendly, 2-page PDFs with NO browser header/footer
# (no date / URL / page numbers) — unlike printing from the browser dialog.
#
# Local use (macOS): ./build-pdf.sh
# CI use: set CHROME to the browser path and CHROME_FLAGS="--no-sandbox".
#
# Requires Google Chrome (headless).
set -euo pipefail
cd "$(dirname "$0")"

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
CHROME_FLAGS="${CHROME_FLAGS:-}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# English (default language)
"$CHROME" --headless $CHROME_FLAGS --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$PWD/Carlos-Vega-CV-EN.pdf" "file://$PWD/index.html" 2>/dev/null

# Spanish: click the language toggle on load, then render
sed 's#</body>#<script>var b=document.getElementById("langBtn");if(b)b.click();</script></body>#' \
  index.html > "$TMP/es.html"
"$CHROME" --headless $CHROME_FLAGS --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$PWD/Carlos-Vega-CV-ES.pdf" "file://$TMP/es.html" 2>/dev/null

echo "Generated Carlos-Vega-CV-EN.pdf and Carlos-Vega-CV-ES.pdf"
