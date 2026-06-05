#!/usr/bin/env bash
# Deploys the wiki pages to the GitHub Wiki repository.
# Usage: bash wiki/deploy-wiki.sh
#
# Prerequisites:
#   - Git authenticated with push access to the repo
#   - Wiki must be enabled in repository settings (Settings → Features → Wiki)
#   - If the wiki is empty, GitHub will auto-initialize it on first push

set -euo pipefail

REPO_WIKI_URL="https://github.com/emilgent/avelan-translator.wiki.git"
TMPDIR=$(mktemp -d)

echo "→ Cloning wiki repo..."
if ! git clone "$REPO_WIKI_URL" "$TMPDIR" 2>/dev/null; then
  echo "→ Wiki repo not yet initialized. Creating fresh repo..."
  git init "$TMPDIR"
  cd "$TMPDIR"
  git remote add origin "$REPO_WIKI_URL"
else
  cd "$TMPDIR"
fi

echo "→ Copying wiki pages..."
cp "$(dirname "$0")"/*.md "$TMPDIR/" 2>/dev/null || true

# Remove the deploy script from the wiki
rm -f "$TMPDIR/deploy-wiki.sh"

cd "$TMPDIR"
git add -A
git commit -m "Wiki: Home, Projektstruktur, Übersetzungs-Engine, Vokabular, Benutzeroberfläche" || echo "No changes to commit"
git push -u origin master 2>/dev/null || git push -u origin HEAD:refs/heads/master

echo "✓ Wiki deployed: https://github.com/emilgent/avelan-translator/wiki"

# Cleanup
rm -rf "$TMPDIR"
