// ── Sanzo Wada · A Dictionary of Colour Combinations ──

#set document(
  title: "A Dictionary of Colour Combinations — Sanzo Wada",
  author: "Sanzo Wada",
)

#set page(
  paper: "a4",
  margin: (top: 11mm, bottom: 9mm, left: 9mm, right: 9mm),
  numbering: "1",
  header: context {
    let pg = here().page()
    if pg > 1 {
      set text(size: 7pt, fill: luma(130))
      let on-page = query(heading.where(level: 2)).filter(it => it.location().page() == pg)
      grid(
        columns: (1fr, 1fr),
        smallcaps[A Dictionary of Colour Combinations],
        align(right)[
          #if on-page.len() > 0 [
            #on-page.first().body – #on-page.last().body
          ] else [
            Sanzo Wada
          ]
        ],
      )
      v(-2pt)
      line(length: 100%, stroke: 0.3pt + luma(200))
    }
  },
)
#set text(font: ("SF Pro", "Helvetica Neue", "Arial"), size: 8pt)
#set heading(numbering: none, outlined: false, bookmarked: false)
// Headings are used purely to populate the PDF outline/bookmark panel —
// give them inline styling instead of the default block spacing so they
// can sit inside the swatch grid without disturbing the layout.
#show heading.where(level: 1): it => text(size: 12pt, weight: "bold")[#it.body]
#show heading.where(level: 2): it => text(size: 9pt, weight: "bold")[#it.body]

// ── Load data ──
#let data = json("../data/colours.json")
#let colors = data.colors
#let combos = data.combinations

#let get-color(id) = colors.at(id - 1)
#let combo-colors(c) = c.colorIds.map(id => get-color(id))

#let cmyk-fmt(c) = (
  "C" + str(c.cmyk.at(0)) + " M" + str(c.cmyk.at(1))
  + " Y" + str(c.cmyk.at(2)) + " K" + str(c.cmyk.at(3))
)

// pick readable text colour for a given swatch
#let contrast-text(hex) = {
  let c = rgb(hex).components(alpha: false)
  let lum = 0.299 * (c.at(0) / 1%) + 0.587 * (c.at(1) / 1%) + 0.114 * (c.at(2) / 1%)
  if lum > 55 { rgb("#1a1a1a") } else { rgb("#fafafa") }
}

#let combo-label(id) = label("combo-" + str(id))
#let color-label(id) = label("color-" + str(id))

// ═══════════════════════════════ TITLE PAGE ═══════════════════════════════

#align(center + horizon)[
  #v(50mm)
  #text(size: 26pt, weight: "bold")[A Dictionary of\ Colour Combinations]
  #v(6mm)
  #text(size: 13pt, style: "italic")[Sanzo Wada]
  #v(6mm)
  #text(size: 9.5pt)[
    #data.meta.totalColors colours in #data.meta.totalCombinations combinations
  ]
  #v(14mm)
  #block(width: 90mm)[
    #set text(size: 7.5pt, fill: luma(110))
    #align(center)[
      Digital edition. Use the PDF outline panel to jump straight to a
      combination number, or the colour index at the back to find every
      combination a given colour appears in — every number is a live link. \
      #v(2mm)
      CMYK values are authoritative for print; sRGB swatches are screen
      approximations only.
    ]
  ]
]

#pagebreak()

// ═══════════════════════════ COMBINATIONS ══════════════════════════════

#let swatch-h = 9mm

#for c in combos {
  let cc = combo-colors(c)
  let n = cc.len()

  block(breakable: false, above: 0pt, below: 1.3mm, grid(
    columns: (7mm, 1fr),
    rows: (swatch-h, auto),
    column-gutter: 2.5mm,
    row-gutter: 0pt,
    align: (center + horizon, left + top),
    // Row 1, col 1: id number, vertically centred against the swatch
    // bars only (not the labels below) — also doubles as a PDF bookmark.
    [
      #heading(level: 2, outlined: true, bookmarked: true)[
        #text(size: 8pt, weight: "bold")[#c.id]
      ]#combo-label(c.id)
    ],
    // Row 1, col 2: the swatch bars
    grid(
      columns: (1fr,) * n,
      column-gutter: 1pt,
      ..cc.map(col => rect(
        fill: rgb(col.hex),
        width: 100%,
        height: swatch-h,
        inset: (bottom: 1mm, left: 1mm),
        radius: 1pt,
      )[
        #align(horizon)[
          #text(size: 5pt, fill: contrast-text(col.hex), font: ("SF Pro", "Helvetica Neue", "Arial"))[#col.hex]
        ]
      ]),
    ),
    // Row 2, col 1: empty (keeps the number aligned to row 1 only)
    [],
    // Row 2, col 2: names + CMYK, one column per swatch above
    grid(
      columns: (1fr,) * n,
      column-gutter: 1pt,
      ..cc.map(col => block(
        width: 100%,
        inset: (top: 0.8mm, bottom: 0pt, left: 1mm),
      )[
        #link(color-label(col.id))[
          #text(weight: "bold", size: 6pt)[#col.name]
        ] \
        #text(size: 5pt, fill: luma(100))[#cmyk-fmt(col)]
      ]),
    ),
  ))
}

#pagebreak()

// ═══════════════════════════ COLOUR INDEX ══════════════════════════════

#heading(level: 1, outlined: true, bookmarked: true)[Colour Index]
#v(3mm)
#text(size: 7pt, fill: luma(110))[
  Every colour, alphabetically, with the combinations it appears in — tap a
  number to jump there.
]
#v(4mm)

#let sorted-colors = colors.sorted(key: col => col.name)

#for col in sorted-colors [
  #block(breakable: false, above: 0pt, below: 2.2mm)[
    #grid(
      columns: (5mm, 1fr),
      column-gutter: 2mm,
      align: (horizon, horizon),
      rect(fill: rgb(col.hex), width: 5mm, height: 5mm, radius: 1pt),
      [
        #text(weight: "bold", size: 7pt)[#col.name]
        #text(size: 6pt, fill: luma(120))[· #col.hex · #cmyk-fmt(col)]
        #linebreak()
        #text(size: 6pt, fill: luma(140))[In: ]
        #for (i, cid) in col.combinations.enumerate() [
          #link(combo-label(cid))[#text(size: 6pt)[#cid]]#if i < col.combinations.len() - 1 [, ]
        ]
      ],
    )
  ]#color-label(col.id)
]
