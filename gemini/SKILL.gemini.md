---
name: kos-finder-id
description: Find and rank Indonesian boarding houses (kos/kost/kosan) near any landmark, address, or coordinates within a budget and gender preference (Putra, Putri, Campur), then produce a single interactive HTML map page in Canvas mode with filters, distance circles, and WhatsApp/Maps buttons. Use when the user asks to cari kos, find a kost near an office, campus, station or MRT, compare kos within a budget, or wants a kos map.
---

# Kos Finder Indonesia

Find real kos listings near a place in Indonesia, rank them, and render one interactive HTML map page using Canvas mode.

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

## Step 5: Build and Open the HTML in Canvas Mode

Open `assets/template.html` in this skill. Build the **complete file** (`kos-report.html`) with these changes:

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
4. Don't change the rest of the template. Keep both Esri map layers (street and satellite) and the tile-failure fallback described below.
5. **Always open and render the generated HTML in Canvas mode** (using the web code canvas / preview tool so it opens directly as an interactive preview panel for the user, instead of only dumping raw HTML text in chat). Do not cut the file short or write "rest unchanged".
6. If Canvas is not available, output the complete file in one `html` code block instead, and tell the user to save it as `kos-report.html` and double-click it.

### Aturan Teknis Peta Interaktif (Wajib untuk Kompatibilitas Preview & Lokal)

Semua aturan ini sudah ada di `assets/template.html`. Jangan diubah.

1. **Jangan gunakan `tile.openstreetmap.org`**: Server publik OpenStreetMap memblokir permintaan dari iframe/sandbox preview dengan status `403 Access Blocked`.
2. **Gunakan Esri ArcGIS Tile Server (Tanpa API Key)**:
   - **Peta Jalan (Default):** `https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}`
   - **Peta Satelit:** `https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}`
3. **Fallback otomatis (`tileerror`)**: Template memasang event listener `tileerror` pada layer peta. Jika tile gagal dimuat berulang kali dan belum ada yang berhasil (misalnya offline atau diblokir jaringan ketat), tile layer dihapus dan latar `#map` berubah menjadi grid bersih, sambil tetap menampilkan marker dan lingkaran radius jarak (`500m`, `1km`, `2km`).
4. **Output dalam Single-File HTML (`kos-report.html`)**: Pastikan seluruh CSS, data kos, dan logika berada dalam satu file `.html` mandiri agar bisa langsung dirender di Canvas / panel Preview maupun dibuka langsung (`file:///`) di browser pengguna tanpa perlu server lokal. Library Leaflet dimuat dari CDN (unpkg), jadi tetap perlu koneksi internet.

## Step 6: Summarize and Share Next Steps

1. Let the user know the interactive map (`kos-report.html`) is open in **Canvas mode**, and they can also download/save it from Canvas or open it directly (`file:///`) in their browser without a local server.
2. Mention that prices and availability change often, so confirm with the owner before paying anything, and that distances are estimates.
3. Give a short summary: the top 5 with price and distance, and anything you couldn't verify.
