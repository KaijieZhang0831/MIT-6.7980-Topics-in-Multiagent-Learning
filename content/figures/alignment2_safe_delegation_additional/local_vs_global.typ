// Section 3d (L14): what a reviewer compares at one step (a), and the actual run (b).
#set page(width: auto, height: auto, fill: none, margin: .5mm)
#import "../libs/typography.typ": figure-font, figure-style
#set text(font: figure-font, size: 9pt)
#show: figure-style
#import "@preview/cetz:0.4.1"

#let c-prop = rgb("#e07a1f")
#let c-base = rgb("#5c6b7a")
#let c-node = rgb("#1d3557")

#box(
  fill: blue.lighten(97%),
  radius: 2mm,
  inset: (x: 3mm, y: 2.5mm),
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    let arr(col) = (end: "stealth", fill: col, scale: .7)
    let node(p, body: none, big: false) = {
      circle(p, radius: if big { 0.36 } else { 0.11 }, fill: if big { white } else { c-node.lighten(70%) }, stroke: .9pt + c-node)
      if big { content(p, text(size: 9pt)[#body]) }
    }
    let solid(p, q, col) = line(p, q, stroke: 1.3pt + col, mark: arr(col))
    let dashed(p, q) = line(p, q, stroke: (paint: c-base, thickness: 1pt, dash: "dashed"), mark: arr(c-base))

    // ------------------------------------------------------------ (a) one vote
    content((-0.5, 3.75), anchor: "west", text(weight: "bold")[(a)])
    let y = (0.2, 2.0)
    node(y, body: $y_t$, big: true)
    // first action from q_t, then the baseline
    solid((0.5, 2.25), (1.5, 3.03), c-prop)
    content((0.85, 2.85), anchor: "south-east", text(fill: c-prop)[$a ~ q_t$])
    node((1.6, 3.1))
    dashed((1.73, 3.1), (2.47, 3.1))
    node((2.6, 3.1))
    dashed((2.73, 3.1), (3.47, 3.1))
    content((2.1, 3.18), anchor: "south", text(size: 8pt, fill: c-base)[$pi_0$])
    content((3.1, 3.18), anchor: "south", text(size: 8pt, fill: c-base)[$pi_0$])
    content((3.6, 3.1), anchor: "west", $EE_(a ~ q_t)[Q^(pi_0)(u_i, a, y_t)]$)
    // the baseline from the start
    dashed((0.5, 1.75), (1.5, 0.97))
    content((0.85, 1.12), anchor: "north-east", text(size: 8pt, fill: c-base)[$pi_0$])
    node((1.6, 0.9))
    dashed((1.73, 0.9), (2.47, 0.9))
    node((2.6, 0.9))
    dashed((2.73, 0.9), (3.47, 0.9))
    content((3.6, 0.9), anchor: "west", $V^(pi_0)(u_i, y_t)$)
    // the vote
    content((4.85, 2.0), text(size: 9pt)[$"Adv"_i (q_t, y_t) >= 0 quad arrow.r.double quad$ approve])
    line((4.85, 2.85), (4.85, 2.3), stroke: .5pt + luma(55%))
    line((4.85, 1.15), (4.85, 1.7), stroke: .5pt + luma(55%))

    // ------------------------------------------------------------ (b) the actual run
    let x0 = 8.0
    content((x0 - 0.65, 3.75), anchor: "west", text(weight: "bold")[(b)])
    let xs = (x0, x0 + 1.85, x0 + 3.7, x0 + 5.55)
    let yy = 2.35
    for (i, x) in xs.enumerate() { node((x, yy), body: $y_#i$, big: true) }
    content((xs.at(3) + 0.7, yy), $dots.c$)
    // step 0 executed, step 1 rejected, step 2 executed
    let steps = ((c-prop, $a_0 ~ q_0$), (c-base, $a_1 ~ pi_0$), (c-prop, $a_2 ~ q_2$))
    for (i, (col, lab)) in steps.enumerate() {
      line((xs.at(i) + 0.4, yy), (xs.at(i + 1) - 0.4, yy), stroke: 1.3pt + col, mark: arr(col))
      content(((xs.at(i) + xs.at(i + 1)) / 2, yy + 0.12), anchor: "south", text(size: 8pt, fill: col)[#lab])
    }
    content((x0 + 2.8, 0.9), $J(u_A) - V^(pi_0)(u_A, y_0) = EE[sum_(t >= 0) gamma^t "Adv"_A (a_t, y_t)]$)
  }),
)
