#!/bin/bash

# 💾 Backup current previous.json
cp data/previous.json data/previous.json.bak

# 🔍 Extract a real game title from latest.json
GAME_TO_REMOVE=$(jq -r '.[0].productTitle' output/latest.json)
echo "🚮 Removing from previous.json: $GAME_TO_REMOVE"

# 🧹 Remove that title from previous.json
jq --arg title "$GAME_TO_REMOVE" 'map(select(.productTitle != $title))' data/previous.json > tmp && mv tmp data/previous.json

# 🧪 Inject a fake game for removal simulation
echo "🧪 Injecting fake game into previous.json"
jq '. + [{"productTitle":"Test Removal Game","productId":"00000000"}]' data/previous.json > tmp && mv tmp data/previous.json

echo "✅ Setup complete. Now run: ./run.sh"

