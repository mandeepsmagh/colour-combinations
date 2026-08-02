# A Dictionary of Colour Combinations

[**Sanzo Wada**](https://en.wikipedia.org/wiki/Sanzo_Wada) (1883–1967) published a six-volume work *A Dictionary of Color Combinations* — 348 curated colour palettes. This is a digital reference built from that collection.

**159 colours · 348 combinations**

---

## Files

| File | Purpose |
|---|---|
| `index.html` | Web viewer — open in any browser, no server needed |
| `data/colours.json` | Complete dataset (CMYK + hex, pre-computed combinations) |
| `print/swatches.typ` | Typst template for printable PDF swatch book |
| `print/swatches.pdf` | Pre-compiled PDF (bookmarks, colour index, internal links) |

Everything is self-contained. No dependencies, no build step, no framework.

## Quick start

**Web viewer:** double-click `index.html`.

**PDF:** run `typst compile --root . print/swatches.typ` to regenerate.

## Data format

`colours.json` stores CMYK as the source of truth — these are the values you take into print software. Hex values are sRGB approximations for screen display.

```json
{
  "meta": { "source": "...", "volumes": 6, "totalColors": 159, "totalCombinations": 348 },
  "colors": [
    { "id": 1, "name": "Hermosa Pink", "cmyk": [0, 30, 6, 0], "hex": "#f9c1ce", "combinations": [176, 227, 273] }
  ],
  "combinations": [
    { "id": 1, "colorIds": [66, 118] }
  ]
}
```

Both directions are pre-computed — look up a colour to find its combinations, or a combination to find its colours.

## Credits

- Colour data derived from [Matt DesLauriers](https://github.com/mattdesl/dictionary-of-colour-combinations)
- Original web implementations: [sanzo-wada](https://github.com/dblodorn/sanzo-wada) by Dain M. Blodorn Kim and [color-combinations-sanzo-wada-public](https://github.com/bravokiloecho/color-combinations-sanzo-wada-public) by Ben Elwyn
- This version simplifies both into a single HTML file and a single Typst template — no dependencies, no build tools

## License

MIT
