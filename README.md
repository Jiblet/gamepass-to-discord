# gamepass-to-discord

Monitors Xbox Game Pass title changes and posts updates straight to Discord using sexy embeds and webhook magic.

## Setup

Run the install:
`npm install`

Then drop a `.env` in the root containing your webhook URL: `DISCORD_WEBHOOK_URL="your-discord-webhook-url"`

## Usage

Run the pipeline:
`./run.sh`

## Testing

Inject a fake change for sanity check:
`./simulate-test.sh`

## Structure

- `run.sh`: master script, formats + posts  
- `simulate-test.sh`: spoof a game add/remove  
- `index.js`: pulls current game list  
- `tracker.js`: diffs and formats Discord embeds  
- `config.json`: tweak output rules + images  
- `data/previous.json`: cached list  
- `output/latest.json`: fresh list  
- `.env`: webhook token (ignored from Git)


## Notes

- Splits embeds into 10s to play nice with Discord
- Posts fallback message if no titles changed
- Uses webhook from .env — no secrets tracked

## License

MIT  
Author: Jiblet  

## Attribution

Original code source: https://github.com/NikkelM/Game-Pass-API (MIT License)

