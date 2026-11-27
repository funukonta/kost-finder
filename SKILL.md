---
name: kos-finder-id
description: Search, cross-verify, and rank Indonesian boarding houses (kos/kost) around any user-specified landmark, address, or GPS coordinates within a target budget and gender preference (Putra, Putri, Campur), then generate an interactive split-view HTML report with a free Leaflet map (Esri tiles), distance radius circles, route polylines, filters, and WhatsApp/Mamikos/Maps action buttons. Use when the user asks to find kos/kost/kosan, cari kos dekat kantor/kampus/stasiun/MRT, compare kos options within a budget, or build an interactive kos map report.
---

# Kos Finder Indonesia (`kos-finder-id`)

Find, verify, and visualize boarding houses (*kos/kost*) around a target location or coordinate in Indonesia, ranked by **Top Recommendations (#1–5)** followed by **Distance Order (#6–N)**, and output a self-contained interactive **Leaflet + Esri tiles HTML dashboard**.

---

## Workflow

### Step 1: Clarify Missing Requirements
Check if the user has already provided:
1. **Target Location / Landmark / Coordinates** (e.g., `"Plaza Oleos TB Simatupang"`, `"MRT Blok M"`, or `"-6.29865, 106.82975"`).
2. **Maximum Monthly Budget** (e.g., `Rp 2.500.000`).
3. **Kos Type Preference**:
   - Khusus Putra (Male)
   - Khusus Putri (Female)
   - Putra & Campur (Male + Mixed — exclude Putri)
   - Putri & Campur (Female + Mixed — exclude Putra)
   - Semua Tipe (Putra, Putri, Campur)
4. **Target Count** (default: 20–30 listings if not specified).

If **Kos Type** or **Budget** is missing and materially affects the search, ask a single concise question using `ask_user_question` before scraping.

---

### Step 2: Resolve Center Coordinates & Surrounding Sub-areas
1. Identify the exact latitude/longitude of the target landmark or use the coordinates provided by the user.
2. Identify the immediate *kelurahan*, *kecamatan*, and main streets/alleys (*jalan/gang*) within a **0.2 km – 2.2 km radius** of the landmark.
   - *Tip:* Note physical barriers such as toll roads (JORR), rivers, or railways so you can advise which side of the road allows walking without crossing major highways.

---

### Step 3: Multi-Source Search & Cross-Verification
Search and extract real kos listings from multiple Indonesian kos directories. If `web_search` is unavailable or rate-limited, use `web_fetch` with DuckDuckGo HTML (`https://html.duckduckgo.com/html/?q=...`) and direct directory tag pages:

1. **Mamikos** (`site:mamikos.com/room kost <kelurahan> <kecamatan>`)
   - Tip: Appending `.md` to Mamikos room URLs (or fetching the DuckDuckGo `.md` snippet) often exposes structured room metadata (price, room size, availability, facilities, last updated date).
2. **KostJakarta / KostMurah / Tempat-Kost** (`https://www.kostjakarta.com/tag/<area>/`, `https://www.kostmurah.com/daerah/<area>/`)
   - Provides direct owner WhatsApp numbers, exact street/RT/RW addresses, room dimensions, electricity/laundry inclusions, and parking availability.
3. **Infokost & RajaKost** (`site:infokost.id`, `site:rajakost.com`)
4. **Coliving Operators** (`Rukita`, `Cove`, ` Singgahsini`, ` Apik`) when budget allows.

#### Accuracy & Cross-Check Rules
- **Filter strictly by gender type**: If the user is male and wants *Putra / Campur*, **strictly exclude** all *Kost Putri*. If the user is female and wants *Putri / Campur*, **strictly exclude** all *Kost Putra*.
- **Filter by budget**: Keep monthly rent `<= budget` (or clearly note when a multi-month package brings the monthly average under budget).
- **Cross-check high-interest listings**: When a listing has unusually good perks on an older directory (e.g., free laundry or old promo price), cross-check against its latest Mamikos/RajaKost page and report both the verified current price and minimum stay terms honestly.

---

### Step 4: Rank Listings (#1–5 Best Recommendations, #6–N by Distance)
Structure the final list of $N$ kos listings as follows:
- **#1 to #5 — Top 5 Recommendations (`recommended: true`)**:
  Select the 5 best overall options balancing **walking distance (<1 km)**, **room size**, **value for money**, **verified facilities** (AC, Kamar Mandi Dalam, WiFi, Water Heater, cleaning/laundry/parking), and **same-side road access** (no highway crossing). Give each a clear `highlight` badge explaining *why* it is recommended.
- **#6 to #N — Ordered Strictly by Distance (`recommended: false`)**:
  Sort all remaining listings from closest (`± 300 m`) to farthest (`± 2.0 km`) from the target landmark.

---

### Step 5: Generate the Interactive HTML Report (Leaflet + Esri tiles)
Read `assets/template.html` in this skill directory and use it as the base template to write both:
- `<slug>-kos-report.html` (or user-requested filename)
- `index.html` (if writing inside a dedicated project folder so `python3 -m http.server 8000` serves it immediately at `http://localhost:8000/`).

#### Mandatory Map & UI Requirements (Zero API Key Errors!)
1. **Free Tile Layers Only (No API Key Required)**:
   - Use the Esri ArcGIS layers already in `assets/template.html`:
     - Street map (default): `https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}`
     - Satellite: `https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}`
   - **Why Esri:** `tile.openstreetmap.org` returns `403 Access Blocked` for requests with no `Referer` (a double-clicked `file://` page) and for sandboxed iframe previews. Esri works in both.
   - **Fallback:** the template listens for `tileerror`. If tiles keep failing with none loaded (offline, strict network), it removes the tile layers and shows a clean grid, keeping markers and radius circles.
   - Never use `tile.openstreetmap.org`, Stadia, Mapbox, or Google Maps JS API tiles; they are blocked or need an API key.
2. **Standard Google Maps Links**:
   - Use `https://www.google.com/maps?q=<encoded_query>` for external Google Maps buttons.
3. **Visual Map Features**:
   - Center marker (`🏢`) at the target landmark with a red badge.
   - Radius circles at **500m** (walking zone), **1,000m** (short ride zone), and **2,000m**.
   - Color-coded numbered pins (`#1`–`#N`) for Top Recommendations, Favorite/Highlighted Kos, Kos Putra, Kos Putri, and Kos Campur.
   - Clicking any card or `"🎯 Lihat di Peta"` button pans/zooms the map, opens the marker popup, and draws a dashed polyline from the target landmark to that kos.
   - Interactive search input + filter buttons by Kos Type and Top Recommendations.

---

### Step 6: Provide Run Instructions
After writing the HTML file(s), tell the user:
1. The exact file path generated.
2. That they can simply double-click the HTML file to open it. No server needed.
