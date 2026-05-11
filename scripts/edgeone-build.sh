#!/usr/bin/env bash
# Assemble a clean static output tree for Tencent EdgeOne Pages (Linux builder).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if command -v git-lfs >/dev/null 2>&1; then
  git lfs install
  git lfs pull || true
fi

rm -rf dist
mkdir -p dist/Build

cp index.html dist/
cp dependencies.txt GUID.txt ProjectVersion.txt dist/ 2>/dev/null || true

cp Build/ygwenjianjia.loader.js \
   Build/ygwenjianjia.framework.js \
   Build/ygwenjianjia.wasm \
   Build/ygwenjianjia.data \
   dist/Build/

cp -r TemplateData StreamingAssets dist/
touch dist/.nojekyll

echo "EdgeOne build output ready at dist/"
