#!/bin/bash
# 🌐 Load webhook from .env
if [ -f .env ]; then
  source .env
else
  echo "❌ .env file missing. Create one with DISCORD_WEBHOOK_URL"
  exit 1
fi

# 🔁 Refresh latest game list
node index.js

jq -s 'add' \
  output/formattedGameProperties_pc_GB.json \
  output/formattedGameProperties_eaPlay_GB.json \
  > output/latest.json

# 🧠 Diff and build embeds
EMBEDS=$(node tracker.js)

# 📨 Post to Discord
if [ "$EMBEDS" != "[]" ]; then
  echo "$EMBEDS" | jq -c '.[]' | split -l 10 - tmp_embed_

  for f in tmp_embed_*; do
    batch=$(jq -s '.' "$f")
    curl -H "Content-Type: application/json" \
         -X POST \
         -d "{\"embeds\": $batch}" \
         "$DISCORD_WEBHOOK_URL"
    rm "$f"
  done
else
  curl -H "Content-Type: application/json" \
       -X POST \
       -d "{\"content\": \"✅ No changes in Game Pass titles.\"}" \
       "$DISCORD_WEBHOOK_URL"
fi

