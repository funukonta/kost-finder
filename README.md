# 🏠 Kost Finder

**Cari kos tanpa 47 tab terbuka.**

Tell your AI assistant where you'll be working or studying, how much you can spend, and who the kos is for. It does the digging, then hands you a map you can actually play with.

---

## ✨ What you get

Ask for kos near *MRT Blok M, under Rp 2.500.000, putri*, and you get a single page that opens in your browser:

- 🗺️ **A live map** with every kos pinned, plus walking and short-ride circles around your destination
- 🏆 **A Top 5**, picked for distance, room size, value, and facilities
- 📏 **The rest sorted by distance**, nearest first
- 🔍 **Filters and search** for Putra, Putri, Campur, or just the top picks
- 🎯 **One tap to see the route** from your landmark to any kos
- 💬 **Buttons to chat on WhatsApp**, or open the listing on Mamikos or Google Maps

No API keys. No sign-ups. No cost.

---

## 💬 How to use it

Just talk to it:

> "Cari kos putri dekat Stasiun Sudirman, budget 3 juta"

> "Find me a kos near Plaza Oleos, max 2.5 juta, putra or campur"

> "Bandingkan kos sekitar kampus UI Depok, 20 pilihan"

It will ask if it's missing your budget or the kos type. After that it does the work.

---

## 🔎 How it picks

- **Checks several sources**: Mamikos, KostJakarta, KostMurah, RajaKost and more
- **Respects who the kos is for**: no Putri listings if you need Putra, and the other way round
- **Stays in budget**
- **Double-checks the good deals**: if a listing looks too good, it compares the price against newer pages and tells you what's real
- **Looks at the walk**: it notes highways and rivers in the way, not just straight-line distance

---

## 📦 Install

**Using Gemini (easiest, works in your browser)**

1. Download [`gemini/kos-finder-id.zip`](gemini/kos-finder-id.zip) from this repo.
2. Open [gemini.google.com](https://gemini.google.com) and go to **Skills**.
3. Click **Create → Upload** and pick the zip.
4. In any chat, type `/` or `@`, choose **kos-finder-id**, and say what you're looking for.

Gemini opens your map in Canvas so you can use it right in the chat. You can also download it and double-click the file later.

**Using a coding assistant (Claude Code, Pi, Gemini CLI, etc.)**

```bash
git clone https://github.com/funukonta/kost-finder.git ~/.agents/skills/kos-finder-id
```

Then ask it to find you a kos. This version searches the web and saves the HTML file for you.

## 🚀 Open your results

Double-click the HTML file. That's it, the map loads right in your browser. No server, no setup.

## 📍 Good to know

- Listings and prices change fast. **Always confirm with the owner** before you transfer any money.
- Distances are estimates. Check the route on Google Maps before you sign.

Happy hunting! 🛏️
