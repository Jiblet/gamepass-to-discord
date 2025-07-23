import fs from "fs";
import https from "https";

// Load current and previous datasets
const curr = JSON.parse(fs.readFileSync("output/latest.json", "utf8"));
const prev = fs.existsSync("data/previous.json")
  ? JSON.parse(fs.readFileSync("data/previous.json", "utf8"))
  : [];

const currTitles = new Set(curr.map(g => g.productTitle));
const prevTitles = new Set(prev.map(g => g.productTitle));

const added = curr.filter(g => !prevTitles.has(g.productTitle));
const removed = prev.filter(g => !currTitles.has(g.productTitle));

// Create store URL
function getStoreUrl(game) {
  if (!game.productTitle || !game.productId) return null;

  const slug = game.productTitle.toLowerCase()
    .replace(/[^a-z0-9]/g, "-")
    .replace(/-+/g, "-")
    .replace(/^-|-$/g, "");

  return `https://www.xbox.com/en-gb/games/store/${slug}/${game.productId}`;
}

// Try image types in fallback order
function getPreferredImage(images) {
  const types = [
    "Poster",
    "SuperHeroArt",
    "TitledHeroArt",
    "BrandedKeyArt",
    "Screenshot"
  ];
  for (const type of types) {
    const url = images?.[type]?.[0];
    if (url && isProbablyValid(url)) return url;
  }
  return null;
}

// Quick filter for sketchy links
function isProbablyValid(url) {
  return typeof url === "string" && /^https:\/\/store-images\.s-microsoft\.com\/image\/apps\./.test(url);
}

// Build embed blocks
const embeds = [];

[["🟢 Added", added, 5763719], ["🔴 Removed", removed, 15548997]].forEach(([label, list, color]) => {
  list.forEach(game => {
    const url = getStoreUrl(game);
    if (!url) return;

    const image = getPreferredImage(game.images);
    const embed = {
      title: `${label}: ${game.productTitle}`,
      description: `[View on Xbox Store](${url})`,
      url,
      color,
      timestamp: new Date().toISOString()
    };
    if (image) embed.thumbnail = { url: image };

    embeds.push(embed);
  });
});

// Save latest set for next diff
fs.writeFileSync("data/previous.json", JSON.stringify(curr, null, 2));
console.log(JSON.stringify(embeds));

