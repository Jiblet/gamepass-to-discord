# gamepass-to-discord

Tracks Xbox Game Pass title changes and posts updates to Discord via webhook embeds.

## Setup

npm install

Create a .env file:

DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/your-webhook-url"

## Usage

./run.sh

## Testing

./simulate-test.sh

## Files

- run.sh – executes the workflow
- simulate-test.sh – injects test data
- index.js – builds latest game list
- tracker.js – diffs previous vs current
- config.json – formatting config
- data/previous.json – cached data
- output/latest.json – current game list
- .env – webhook token (ignored from Git)

## License

MIT  
Author: Jiblet

