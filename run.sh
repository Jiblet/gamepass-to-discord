#!/bin/bash
cd "$(dirname "$0")"

echo "▶️ Game Pass to Discord started at $(date)"

# 🌐 Load webhook from .env
if [ -f .env ]; then
  source .env
else
  echo "❌ .env file missing. Create one with DISCORD_WEBHOOK_URL"
  exit 1
fi

# 🔁 Refresh latest game list
node index.js
if [ $? -ne 0 ]; then
  echo "❌ index.js failed"
  exit 1
fi

# 📦 Merge output files
jq -s 'add' \
  output/formattedGameProperties_pc_GB.json \
  output/formattedGameProperties_eaPlay_GB.json \
  > output/latest.json

# 🧠 Diff and build embeds
EMBEDS=$(node tracker.js)
if [ $? -ne 0 ]; then
  echo "❌ tracker.js failed"
  exit 1
fi

# 📨 Post to Discord if needed
if [ "$EMBEDS" != "[]" ] && [ -n "$EMBEDS" ]; then
  echo "✅ New titles found — preparing Discord embeds"
  echo "$EMBEDS" | jq -c '.[]' | split -l 10 - tmp_embed_

  for f in tmp_embed_*; do
    batch=$(jq -s '.' "$f")
    curl -s -H "Content-Type: application/json" \
         -X POST \
         -d "{\"embeds\": $batch}" \
         "$DISCORD_WEBHOOK_URL"
    echo "📤 Posted batch: $f"
    rm "$f"
  done
else
  echo "ℹ️ No changes detected this hour"
fi

echo "✅ Run finished at $(date)"

