---
name: kos-finder-id
description: Find and rank Indonesian boarding houses (kos/kost/kosan) near any landmark, address, or coordinates within a budget and gender preference (Putra, Putri, Campur), then produce a single interactive HTML map page with filters, distance circles, and WhatsApp/Maps buttons. Use when the user asks to cari kos, find a kost near an office, campus, station or MRT, compare kos within a budget, or wants a kos map.
---

# Kos Finder Indonesia

Find real kos listings near a place in Indonesia, rank them, and hand the user one HTML file with an interactive map.

## Ground rules

- **Never invent a listing.** Every kos must come from a page you found with search. If you can't find enough real listings, return fewer and say so.
- **Never invent phone numbers.** If no WhatsApp number was on the listing, leave `phone` empty. The template then shows a "check the listing" button instead.
- **Coordinates are estimates.** Take them from the listing or map page if shown. Otherwise estimate from the street address and say they are approximate.
- Reply in the user's language (Bahasa Indonesia or English).

## Step 1: Ask what's missing

You need:
1. **Place**: landmark, address, or coordinates (e.g. "MRT Blok M", "-6.29865, 106.82975").
2. **Maximum monthly budget** (e.g. Rp 2.500.000).
3. **Who it's for**: Putra, Putri, Campur, or all. "Putra & Campur" means no Putri; "Putri & Campur" means no Putra.
4. **How many** listings (default 20, fewer is fine).

If the budget or kos type is missing, ask one short question in chat and wait for the answer.

## Step 2: Locate the center

Get the latitude and longitude of the place. Note the neighborhood (kelurahan, kecamatan) and the main streets within about 2 km. Note barriers like toll roads, rivers, or railways, because they change how walkable a kos really is.

## Step 3: Search

Use Google Search. Try queries like:
- `kost <kelurahan> <kecamatan> mamikos`
- `kost dekat <landmark> harga <budget>`
- `kost <area> kostjakarta`, `kost <area> rajakost`, `kost <area> infokost`

Good sources: Mamikos, KostJakarta, KostMurah, RajaKost, Infokost, and coliving brands (Rukita, Cove, Singgahsini, Apik).

If you can't search or open pages, say so plainly and ask the user to paste a few listing links or details. Then continue with what they give you.

### Filtering rules
- Drop any listing that doesn't match the gender preference.
- Keep monthly rent at or under budget. If a multi-month package brings the average under budget, say so.
- If a listing's price or perks look too good (old promo, free laundry), check a newer page for it and report the current price and minimum stay.

## Step 4: Rank

- **#1 to #5, recommended:** the best balance of walking distance (under 1 km), room size, price, verified facilities (AC, private bathroom, WiFi, water heater, cleaning, laundry, parking), and no highway to cross. Give each a short `highlight` saying why.
- **#6 onward:** sort by distance from the center, closest first.

## Step 5: Build the HTML

Open `assets/template.html` in this skill. Output the **complete file** with these changes:

1. Replace `{{CENTER_NAME}}`, `{{CENTER_ADDRESS}}`, and `{{BUDGET_LABEL}}` everywhere they appear.
2. Set `CENTER_POINT.lat` and `CENTER_POINT.lng`.
3. Fill the `kosList` array. One object per kos:
   ```js
   { no: 1, recommended: true, isFav: false, lat: -6.3001, lng: 106.8299,
     highlight: "...", name: "...", type: "Campur", distance: "± 180 m",
     price: "Rp 2.300.000", address: "...", facilities: "AC, KM dalam, WiFi",
     phone: "628123456789", phoneDisplay: "0812-3456-789", externalUrl: "https://..." }
   ```
   - `type` is `"Putra"`, `"Putri"`, or `"Campur"`.
   - `phone` uses the 62 format with no `+` or spaces. Leave it `""` if unknown, and put the source site name in `phoneDisplay` (e.g. `"Mamikos"`).
   - `externalUrl` is the listing page you found.
4. Don't change the rest of the template. Keep both map layers.

Put the whole file in **one code block** (`html`) so it can be copied. Don't cut it short or write "rest unchanged".

## Step 6: Tell the user how to open it

1. Copy the code block into a text editor and save it as `kos-report.html`.
2. Double-click the file. It opens in the browser with the map. No server or sign-up needed.
3. Mention that prices and availability change often, so confirm with the owner before paying anything, and that distances are estimates.
4. Give a short summary: the top 5 with price and distance, and anything you couldn't verify.
