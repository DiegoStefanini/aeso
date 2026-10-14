#import "@preview/cetz:0.4.2": canvas, draw

#set document(title: "AESO — Dispensa")
#set page(paper: "a4", margin: 2.2cm, numbering: "1")
#set text(lang: "it", size: 11pt)
#set par(justify: true)
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => { pagebreak(weak: true); it }
// codice lungo spezzabile, altrimenti lascia mezze pagine bianche
#show raw.where(block: true): it => block(fill: luma(245), inset: 8pt, radius: 4pt, width: 100%, breakable: it.lines.len() > 12, it)
#show raw.where(block: false): box.with(fill: luma(240), inset: (x: 3pt), outset: (y: 3pt), radius: 2pt)
#set table(stroke: 0.5pt + luma(180), inset: 6pt)
#show table.cell.where(y: 0): strong
#show table: it => block(breakable: false, it)

#let blu = rgb("#3b6fd8")
#let verde = rgb("#2e9e5b")
#let grigio = luma(170)
#let azzurro = rgb("#eef4ff")

// osservazione del prof, trappola
#let nota(body) = block(
  fill: rgb("#eef4ff"), stroke: (left: 3pt + blu),
  inset: 10pt, width: 100%, body,
)
// prerequisito non spiegato in aula, aggiunto su richiesta
#let base(titolo, body) = block(
  fill: rgb("#eefaf2"), stroke: (left: 3pt + verde),
  inset: 10pt, width: 100%,
)[*Da sapere — #titolo* #h(0.3em) #text(8pt, fill: verde)[(aggiunto, non spiegato in aula)] \ #body]

// ▶ nel margine sinistro: link al video della lezione su Stream, da `da` ad `a` (mm:ss)
#let b64(s) = {
  let abc = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
  let b = array(bytes(s))
  let out = ""
  for i in range(0, b.len(), step: 3) {
    let g = b.slice(i, calc.min(i + 3, b.len()))
    let n = g.at(0) * 65536 + g.at(1, default: 0) * 256 + g.at(2, default: 0)
    for k in range(g.len() + 1) { out += abc.at(calc.rem(calc.quo(n, calc.pow(64, 3 - k)), 64)) }
  }
  out
}
#let video(file, da, a) = {
  let (m, s) = da.split(":").map(int)
  let nav = "{\"referralInfo\":{\"referralApp\":\"StreamWebApp\",\"referralView\":\"ShareDialog-Link\",\"referralAppPlatform\":\"Web\",\"referralMode\":\"view\"},\"playbackOptions\":{\"startTimeInSeconds\":" + str(m * 60 + s) + "}}"
  let url = "https://unipiit.sharepoint.com/sites/AESOa.2026-27/_layouts/15/stream.aspx?id=%2Fsites%2FAESOa.2026-27%2FShared%20Documents%2FGeneral%2FRegistrazioni%2Faeso-" + file + ".mp4&nav=" + b64(nav)
  context {
    let x = here().position().x
    box(place(dx: 2.2cm - x - 2.05cm, dy: -0.75em, link(url, text(fill: blu, stack(dir: ltr, spacing: 2pt,
      text(13pt)[▶], align(horizon, text(if file.len() > 2 { 6pt } else { 7pt }, font: "DejaVu Sans Mono")[#file · #da \ #h(1.2em)→ #a]))))))
  }
}

// spazi non separabili: Typst taglia gli spazi in coda e i riporti si spostano
#let mono(s) = text(font: "DejaVu Sans Mono", if type(s) == str { s.replace(" ", "\u{a0}") } else { s })
// conto in colonna: righe allineate a destra, riga sopra il risultato
#let conto(op: "+", sopra: (), ..righe) = {
  let r = righe.pos()
  let celle = ()
  for s in sopra { celle += ([], text(fill: grigio, mono(s))) }
  for (i, x) in r.slice(0, -1).enumerate() {
    if i == 2 { celle.push(grid.hline(start: 1, stroke: 0.5pt)) }
    celle += (if i == 1 { op } else { [] }, mono(x))
  }
  celle += (grid.hline(start: 1, stroke: 0.8pt), [], strong(mono(r.last())))
  box(grid(columns: 2, align: right, inset: (x: 2pt, y: 3pt), ..celle))
}
// passaggi etichettati: ((etichetta, bit), ...), riga sopra l'ultimo
#let passi(..righe) = {
  let r = righe.pos()
  let celle = ()
  for (i, (e, x)) in r.enumerate() {
    if i == r.len() - 1 { celle.push(grid.hline(stroke: 0.8pt)) }
    celle += (text(8pt, fill: gray, e), if i == r.len() - 1 { strong(mono(x)) } else { mono(x) })
  }
  box(grid(columns: 2, align: (left, right), inset: (x: 3pt, y: 3pt), ..celle))
}
// pila di livelli: ogni elemento è (testo, colore di sfondo)
#let pila(larghezza: 3.4cm, ..livelli) = stack(..livelli.pos().map(((t, c)) =>
  box(width: larghezza, inset: 5pt, stroke: 0.6pt, fill: c, align(center, text(9pt, t)))))
#let figura(corpo, didascalia) = figure(corpo, caption: didascalia, kind: image, supplement: none)

// simbolo del multiplexer
#let mux = canvas(length: 0.8cm, {
  import draw: *
  line((0, 0), (3, 0), (2.4, -1), (0.6, -1), close: true, fill: rgb("#eef4ff"))
  content((0.8, -0.35), text(9pt)[0]); content((2.2, -0.35), text(9pt)[1])
  content((0.8, 1), [x]); line((0.8, 0.75), (0.8, 0.05), mark: (end: "stealth"))
  content((2.2, 1), [y]); line((2.2, 0.75), (2.2, 0.05), mark: (end: "stealth"))
  line((-0.8, -0.5), (0.25, -0.5), mark: (end: "stealth")); content((-1.05, -0.5), [c])
  line((1.5, -1.05), (1.5, -1.7), mark: (end: "stealth")); content((1.5, -2), [z])
})
// bit di v in complemento a 2 su n bit, a gruppi di 4
#let c2(v, n) = {
  let u = if v < 0 { v + calc.pow(2, n) } else { v }
  let b = range(n).rev().map(i => str(calc.rem(calc.quo(u, calc.pow(2, i)), 2)))
  range(n).map(i => (if i > 0 and calc.rem(n - i, 4) == 0 { " " } else { "" }) + b.at(i)).join()
}
// tabella di verità calcolata: nomi degli ingressi, uscite = ((nome, riga => 0/1), ...)
#let tvb(nomi, ..uscite) = {
  let n = nomi.len()
  let u = uscite.pos()
  let righe = range(calc.pow(2, n)).map(k => range(n).map(i => calc.rem(calc.quo(k, calc.pow(2, n - 1 - i)), 2)))
  block(breakable: false, table(columns: n + u.len(), align: center, inset: 5pt,
    stroke: (x, y) => if x == n - 1 { (right: 1pt) } + if y == 0 { (bottom: 1pt) },
    ..nomi, ..u.map(((t, f)) => t),
    ..righe.map(b => b.map(v => [#v]) + u.map(((t, f)) => {
      let r = f(b)
      if r == 1 { text(fill: blu, weight: "bold")[1] } else if r == 0 [0] else { r }
    })).flatten()))
}
// porte logiche: p = punto medio del lato d'ingresso, h = altezza
#let porta-and(p, h: 0.9) = {
  import draw: *
  let (x, y) = p
  line((x + h / 2, y + h / 2), (x, y + h / 2), (x, y - h / 2), (x + h / 2, y - h / 2))
  arc((x + h / 2, y - h / 2), start: -90deg, stop: 90deg, radius: h / 2)
}
#let porta-or(p, h: 0.9) = {
  import draw: *
  let (x, y) = p
  bezier((x, y + h / 2), (x, y - h / 2), (x + h / 4, y))
  bezier((x, y + h / 2), (x + h * 1.1, y), (x + h * 0.7, y + h / 2))
  bezier((x, y - h / 2), (x + h * 1.1, y), (x + h * 0.7, y - h / 2))
}
#let porta-not(p, h: 0.9) = {
  import draw: *
  let (x, y) = p
  line((x, y + h / 2), (x, y - h / 2), (x + h * 0.8, y), close: true)
  circle((x + h * 0.8 + 0.08, y), radius: 0.08)
}
#let porta-nand(p, h: 0.9) = {
  import draw: *
  porta-and(p, h: h)
  circle((p.at(0) + h + 0.08, p.at(1)), radius: 0.08)
}
// NAND con i due ingressi uniti: fa da NOT
#let nand-not(p) = {
  import draw: *
  let (x, y) = p
  porta-nand(p, h: 0.6)
  line((x, y + 0.15), (x - 0.3, y + 0.15), (x - 0.3, y - 0.15), (x, y - 0.15))
  circle((x - 0.3, y), radius: 0.05, fill: black)
}
#let fr(a, b, ..args) = draw.line(a, b, mark: (end: "stealth"), ..args)
// barretta sul filo con il numero di bit
#let bus(p, n) = {
  import draw: *
  let (x, y) = p
  line((x - 0.12, y - 0.12), (x + 0.12, y + 0.12))
  content((x + 0.3, y + 0.22), text(7pt, n))
}
// trapezio del MUX (largo in alto) o del DEMUX (largo in basso); p = angolo in alto a sinistra
#let trap(p, w: 2, h: 0.7, demux: false, etichette: ("0", "1")) = {
  import draw: *
  let (x, y) = p
  let (su, giu) = if demux { (0.3, 0) } else { (0, 0.3) }
  line((x + su, y), (x + w - su, y), (x + w - giu, y - h), (x + giu, y - h), close: true, fill: azzurro)
  for (k, e) in etichette.enumerate() {
    content((x + w * (k + 0.5) / etichette.len(), if demux { y - h + 0.22 } else { y - 0.22 }), text(7pt, e))
  }
}
// prodotto (AND) di una riga: variabile così com'è se 1, negata se 0, assente se none
#let prodotto(nomi, b) = range(nomi.len()).map(i =>
  if b.at(i) == 1 { nomi.at(i) } else if b.at(i) == 0 { $overline(#nomi.at(i))$ }).filter(v => v != none).join(h(1.5pt))
// somma di prodotti di una funzione f(bit) -> 0/1, ricavata da tutte le righe
#let sdp(nomi, f) = {
  let n = nomi.len()
  let righe = range(calc.pow(2, n)).map(k => range(n).map(i => calc.rem(calc.quo(k, calc.pow(2, n - 1 - i)), 2)))
  $#(righe.filter(b => f(b) == 1).map(b => prodotto(nomi, b)).join($+$))$
}
// rete a due livelli (AND poi OR): termini = liste di 1 / 0 (negato) / none (non collegato)
#let rete-sp(nomi, termini, uscita: $z$, passo: 0.7) = canvas(length: 0.8cm, {
  import draw: *
  let (n, m) = (nomi.len(), termini.len())
  let xa = (n - 1) * passo + 1.6
  let yo = -0.9 - (m - 1) * 1.3 / 2
  for (k, nome) in nomi.enumerate() {
    content((k * passo, 0.5), nome); line((k * passo, 0.2), (k * passo, -0.9 - (m - 1) * 1.3 - 0.6))
  }
  for (j, bits) in termini.enumerate() {
    let yy = -0.9 - j * 1.3
    porta-and((xa, yy))
    let usati = range(n).filter(i => bits.at(i) != none)
    for (q, i) in usati.enumerate() {
      let yi = yy + 0.3 - q * 0.6 / calc.max(usati.len() - 1, 1)
      circle((i * passo, yi), radius: 0.06, fill: black)
      if bits.at(i) == 0 { line((i * passo, yi), (xa - 0.16, yi)); circle((xa - 0.08, yi), radius: 0.08) }
      else { line((i * passo, yi), (xa, yi)) }
    }
    let yin = yo + 0.3 - j * 0.6 / calc.max(m - 1, 1)
    let xr = xa + 1.2 + 0.2 * calc.abs(j - (m - 1) / 2)
    line((xa + 0.9, yy), (xr, yy), (xr, yin), (xa + 2.3, yin))
  }
  porta-or((xa + 2.2, yo), h: 1.2)
  line((xa + 3.5, yo), (xa + 4.3, yo)); content((xa + 4.6, yo), uscita)
})
// catena di FA, da sinistra (bit più pesante) a destra; none disegna i puntini
#let catena-fa(indici) = canvas(length: 0.8cm, {
  import draw: *
  for (k, i) in indici.enumerate() {
    let x = k * 3
    if i == none { content((x + 0.9, 0.4), [⋯]) } else {
      rect((x, 0), (x + 1.8, 0.8), fill: azzurro); content((x + 0.9, 0.4), [FA])
      content((x + 0.35, 1.5), $x_#i$); fr((x + 0.35, 1.25), (x + 0.35, 0.85))
      content((x + 1.45, 1.5), $y_#i$); fr((x + 1.45, 1.25), (x + 1.45, 0.85))
      fr((x + 0.9, -0.05), (x + 0.9, -0.5)); content((x + 0.9, -0.8), $z_#i$)
    }
    fr((x - 0.05, 0.4), (x - if k == 0 { 0.7 } else { 1.15 }, 0.4))
  }
  content((-1.1, 0.4), text(9pt)[rip])
  let xf = (indici.len() - 1) * 3 + 1.8
  fr((xf + 0.9, 0.4), (xf + 0.05, 0.4)); content((xf + 1.1, 0.4), text(9pt)[0])
})
// mappa di Karnaugh: f(bit di colonna, bit di riga) -> 0 / 1 / contenuto; gruppi = (colonna, riga, larghezza, altezza, colore)
#let ordine-mappa(n) = if n == 1 { ((0,), (1,)) } else { ((0, 0), (0, 1), (1, 1), (1, 0)) }
#let kmap(col, rig, f, gruppi: ()) = canvas(length: 0.7cm, {
  import draw: *
  line((-0.9, 0.9), (0, 0))
  content((-0.4, 0.8), anchor: "west", text(8pt, col.join())); content((-0.45, 0.12), anchor: "east", text(8pt, rig.join()))
  for (i, c) in ordine-mappa(col.len()).enumerate() {
    content((i + 0.5, 0.3), text(8pt, c.map(str).join()))
    for (j, r) in ordine-mappa(rig.len()).enumerate() {
      if i == 0 { content((-0.4, -j - 0.5), text(8pt, r.map(str).join())) }
      rect((i, -j), (i + 1, -j - 1))
      let v = f(c, r)
      content((i + 0.5, -j - 0.5), if v == 1 { strong[1] } else if v == 0 { text(fill: grigio)[0] } else { v })
    }
  }
  for (c, r, w, h, colore) in gruppi {
    rect((c + 0.1, -r - 0.1), (c + w - 0.1, -r - h + 0.1), radius: 0.25, stroke: 1.3pt + colore)
  }
})
// if (cond) f(x) else g(x) come circuito
#let se-allora(cond, f, g) = canvas(length: 0.8cm, {
  import draw: *
  content((2, 2.75), $x$); line((2, 2.5), (2, 2.2)); line((-0.95, 2.2), (2.5, 2.2)); fr((-0.95, 2.2), (-0.95, 0))
  for (x, t) in ((1.5, f), (2.5, g)) {
    fr((x, 2.2), (x, 1.65))
    rect((x - 0.45, 1.6), (x + 0.45, 0.9), fill: white); content((x, 1.25), text(9pt, t))
    fr((x, 0.9), (x, 0))
  }
  trap((1, 0), etichette: ("1", "0"))
  rect((-1.6, 0), (-0.3, -0.7), fill: rgb("#fff3c4")); content((-0.95, -0.35), text(9pt, cond))
  fr((-0.3, -0.35), (1.15, -0.35))
  fr((2, -0.7), (2, -1.3)); content((2, -1.6), $z$)
})
#let porta-nor(p, h: 0.9) = {
  import draw: *
  porta-or(p, h: h)
  circle((p.at(0) + h * 1.1 + 0.08, p.at(1)), radius: 0.08)
}
// simulazione passo per passo: passo(i, valore precedente) -> nuovo valore (none = non ancora definito)
#let sim(n, passo) = range(n).fold((), (q, i) => q + (passo(i, if i > 0 { q.last() } else { none }),))
// forme d'onda: segnali = ((nome, valori), ...), un valore per intervallo; righe = intervalli da segnare (fronti del clock)
#let onde(segnali, w: 0.45, righe: ()) = canvas(length: 0.8cm, {
  import draw: *
  let h = 0.45
  let fondo = -(segnali.len() - 1) * 0.8 - 0.1
  for x in righe { line((x * w, 0.6), (x * w, fondo), stroke: (paint: grigio, dash: "dashed")) }
  for (k, (nome, v)) in segnali.enumerate() {
    let y = -k * 0.8
    content((-0.25, y + h / 2), anchor: "east", text(9pt, nome))
    for (i, b) in v.enumerate() {
      let (x0, x1) = (i * w, (i + 1) * w)
      let p = if i > 0 { v.at(i - 1) } else { none }
      if type(b) == str {
        // valore a più bit (uno stato): due linee, il nome a ogni cambio
        line((x0, y), (x1, y), stroke: 1.2pt + blu); line((x0, y + h), (x1, y + h), stroke: 1.2pt + blu)
        if p != b { line((x0, y), (x0, y + h), stroke: 1.2pt + blu); content((x0 + 0.08, y + h / 2), anchor: "west", text(7pt, b)) }
      } else if b == none { rect((x0, y), (x1, y + h), fill: luma(225), stroke: none) } else {
        line((x0, y + b * h), (x1, y + b * h), stroke: 1.2pt + blu)
        if type(p) == int and p != b { line((x0, y), (x0, y + h), stroke: 1.2pt + blu) }
      }
    }
  }
})
// clock: 2 intervalli basso e 2 alto; fronti di salita = intervalli 2, 6, 10, ...
#let clock(n) = range(n).map(i => calc.rem(calc.quo(i, 2), 2))
#let fronti(n) = range(2, n, step: 4)

// sessione di terminale: ```sh ... ``` in riquadro scuro
#show raw.where(lang: "sh"): it => block(fill: rgb("#1f2330"), inset: 9pt, radius: 4pt, width: 100%, {
  set par(justify: false)
  show regex("#.*"): set text(fill: rgb("#8a93a6"))
  show regex("(?m)^\$"): set text(fill: rgb("#7ee787"))
  text(font: "DejaVu Sans Mono", size: 8.5pt, fill: rgb("#e6e6e6"), it.text)
})

#align(center)[
  #v(4cm)
  #text(24pt, weight: "bold")[Architettura degli elaboratori \ e sistemi operativi]
  #v(0.3cm)
  #text(14pt)[Diego Stefanini — prof. Marco Danelutto, a.a. 2026-27]
]
#v(1cm)
#outline(depth: 2)
#v(1fr)
#text(9pt)[#text(fill: blu)[▶] nel margine: cliccando si apre la registrazione della lezione (serve l'account Unipi) accanto c'è il numero del video, poi il minuto da cui parte la spiegazione; sotto, fin dove ascoltare.]

= Fondamenti dei sistemi di elaborazione

== Memoria, processore, istruzioni

Un calcolatore è fatto di due parti che si scambiano dati di continuo: la *memoria* M, che contiene programmi e dati, e il *processore* P, che esegue i programmi.

#figura(canvas(length: 1cm, {
  import draw: *
  // memoria: vettore di celle
  let celle = ("M[0]", "M[1]", "M[2]", "⋮", "M[i]", "⋮")
  for (k, t) in celle.enumerate() {
    rect((0, -k * 0.55), (2.2, -k * 0.55 - 0.55), fill: if t == "M[i]" { rgb("#fff3c4") } else { white })
    content((1.1, -k * 0.55 - 0.275), text(9pt, t))
  }
  content((1.1, 0.4), [*M* memoria])
  content((1.1, -3.75), text(8pt)[1 cella = 1 parola \ (32 o 64 bit)])
  // processore
  rect((4.5, 0.2), (9.5, -3.4), radius: 0.15)
  content((4.85, -0.1), [*P*])
  for r in range(4) { for c in range(4) {
    rect((5 + c * 0.45, -0.6 - r * 0.45), (5.45 + c * 0.45, -1.05 - r * 0.45), fill: rgb("#eef4ff"))
  } }
  content((5.9, -2.65), text(8pt)[REG[0..15], 16 registri])
  rect((7.9, -1.1), (9.1, -1.7), fill: rgb("#fde2e2"))
  content((8.5, -1.4), text(9pt)[PC])
  content((8.5, -2.2), text(8pt)[program \ counter])
  // collegamenti
  line((2.3, -1.4), (4.4, -1.4), mark: (start: "stealth", end: "stealth"))
  bezier((7.9, -1.5), (2.3, -2.475), (5.5, -3.6), stroke: (paint: red, dash: "dashed"), mark: (end: "stealth"))
  content((3.2, -3.25), text(8pt, fill: red)[M[PC]])
}), [Il PC contiene l'indirizzo della prossima istruzione da prendere in memoria])

- La *memoria* è un lungo vettore di celle numerate. Il numero di una cella è il suo *indirizzo*: M[i] è la cella di indirizzo i. Ogni cella contiene una *parola* di 32 o 64 bit (un bit è una cifra 0 o 1, vedi i numeri binari più avanti).
- I *registri* sono poche celle (qui 16) *dentro* il processore: molto più veloci della memoria, ci stanno i dati su cui il processore sta lavorando in quel momento.
- Il *PC* (_program counter_) è un registro speciale: contiene l'indirizzo della prossima istruzione da eseguire. Anche il programma, infatti, sta in memoria.

Una volta avviato, il processore ripete per sempre questi quattro passi, il *ciclo fetch-decode-execute*:

```c
while (true) {
    preleva l'istruzione da M[PC]
    decodifica      // che istruzione è?
    esegue
    scrive i risultati
}
```

Dopo il prelievo il PC passa all'istruzione successiva, così al giro dopo il processore prende quella dopo.

Quali istruzioni esistono dipende dal processore (x86, ARM, RISC-V sono famiglie di processori diverse), ma i tipi sono sempre tre:

#table(
  columns: (auto, auto, 1fr),
  [Tipo], [Istruzioni], [Esempio],
  [operative], [`ADD SUB MUL DIV` \ `AND OR NOT` \ `SHIFT ROT` (sx/dx)], [`ADD R0, R1, R2` #h(0.5em) → #h(0.5em) REG[0] = REG[1] + REG[2] \ `SHIFT` sposta i bit a sinistra o a destra; `ROT` li ruota: il bit che esce da una parte rientra dall'altra],
  [memoria], [`LOAD STORE`], [`LOAD R5, addr` #h(0.5em) → #h(0.5em) REG[5] = M[addr] #h(0.3em) (addr = un indirizzo) \ `STORE` fa il contrario: registro → memoria],
  [salto], [salto], [cambia il PC: la prossima istruzione non è quella dopo],
)

#block(breakable: false, grid(columns: (1fr, 1fr), gutter: 1em, align: horizon,
```
inizio:  ADD R0, R0, R0   ← PC
         ADD R1, R1, R1
         SUB R2, R0, R1
         salto inizio     ─┐
            ↑──────────────┘
```,
[Il PC scende di un'istruzione alla volta; il *salto* lo rimette su `inizio`, quindi il programma ricomincia.]))

A dare il ritmo ai passi del ciclo è il *clock*, un segnale che passa da 0 a 1 e viceversa a intervalli regolari. Ogni passo del processore dura un certo numero di cicli di clock: più cicli al secondo (la *frequenza*, in Hz), più istruzioni al secondo.

#grid(columns: (1.2fr, 1fr), gutter: 1.5em, align: horizon,
figura(canvas(length: 0.8cm, {
  import draw: *
  line((0, 0), (1, 0), (1, 1), (2, 1), (2, 0), (3, 0), (3, 1), (4, 1), (4, 0), (5, 0), (5, 1), (6, 1), (6, 0), (7, 0), stroke: 1.2pt + blu)
  line((1, 1.4), (3, 1.4), mark: (start: "stealth", end: "stealth"))
  content((2, 1.8), text(9pt)[1 ciclo])
  content((3.5, -0.6), text(9pt)[clock a 1 GHz → 1 ciclo = 1 ns])
}), [Il clock scandisce i passi del processore]),
[
  - 1 GHz = $10^9$ cicli al secondo, quindi un ciclo dura $10^(-9)$ s = 1 ns.
  - Il processore è fatto di *transistor*, minuscoli interruttori. Nel Motorola 68000 (fine anni '70) misuravano 20-40 µm, oggi 2 nm _(1000 nm = 1 µm)_.
  - Transistor più piccoli → nello spazio di un processore ne stanno più di uno. Ogni processore sul chip si chiama *core*, il chip è *multicore* (sotto: un chip con un solo processore e uno con quattro core):
  #align(center, stack(dir: ltr, spacing: 1em,
    box(stroke: 0.8pt, inset: 12pt)[P],
    align(horizon)[→],
    box(stroke: 0.8pt, inset: 4pt, grid(columns: 2, gutter: 4pt,
      ..range(4).map(_ => box(stroke: 0.6pt, inset: 6pt, radius: 50%)[P]))),
  ))
])

#base[legge di Moore][Il numero di transistor che si riescono a mettere su un chip raddoppia circa ogni due anni. È per questo che si passa dai µm ai nm e da un processore a più processori sullo stesso chip.]

== Astrazione

Un calcolatore si studia a *livelli di astrazione*: ognuno usa quello sotto senza doverne conoscere i dettagli.

#let az = rgb("#eef4ff")
#let descr(t) = text(fill: luma(80))[ — #t]
#align(center, pila(larghezza: 10cm,
  ([*Applicazioni*], white),
  ([*Sistema operativo* #descr[processi, memoria, file system]], az),
  ([*Architettura* #descr[set di istruzioni (ARMv7)]], az),
  ([*Microarchitettura* #descr[il processore]], az),
  ([*Logica* #descr[componenti: AND, OR, NOT, "memoria"]], az),
  ([*Circuiti digitali* #descr[segnali "1" e "0": FA, MUX]], az),
  ([Circuiti analogici], luma(230)),
  ([Dispositivi], luma(230)),
  ([Fisica #descr[questi ultimi 3 non li facciamo]], luma(230)),
))

Il corso parte dal basso e risale. FA e MUX sono due circuiti che arrivano più avanti: il *full adder* somma una cifra, il *multiplexer* sceglie fra due segnali.

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 1.5em, align: horizon,
stack(
  pila(([*Applicazione* — livello i+1], white), larghezza: 6cm),
  pila(([interfaccia: chiamate al sistema operativo], rgb("#fde2e2")), larghezza: 6cm),
  pila(([*Sistema operativo* — livello i], rgb("#eef4ff")), larghezza: 6cm),
  pila(([interfaccia: istruzioni in linguaggio macchina], rgb("#fde2e2")), larghezza: 6cm),
  pila(([*Architettura* — livello i−1], rgb("#eef4ff")), larghezza: 6cm),
),
[Fra due livelli c'è un'*interfaccia*: l'insieme delle funzionalità che il livello i−1 mette a disposizione del livello i.

Il livello i usa solo l'interfaccia, non sa com'è fatto sotto.]))

*Conseguenza*: un programma gira solo dove trova l'interfaccia per cui è stato scritto. Un'app Android usa le chiamate di sistema di Android: su iOS non ci sono, anche se il processore (ARM) è lo stesso. Al contrario, basta che qualcuno offra l'interfaccia giusta, anche "finta", e il programma gira:

#let x-rosso = text(fill: red, weight: "bold", size: 14pt)[✗]
#let v-verde = text(fill: verde, weight: "bold", size: 14pt)[✓]
#align(center, grid(columns: 3, gutter: 1.2em, align: center + bottom,
  [#pila(([App Android], white), ([Android], rgb("#eef4ff")), ([ARM], luma(230)), larghezza: 2.8cm)
   #x-rosso #pila(([iOS], rgb("#eef4ff")), ([ARM], luma(230)), larghezza: 2.8cm)
   #text(8pt)[stessa architettura, \ SO diverso: non gira]],
  [#pila(([App Windows], white), ([*Wine*], rgb("#fff3c4")), ([Linux], rgb("#eef4ff")), ([x86], luma(230)), larghezza: 2.8cm)
   #v-verde \ #text(8pt)[Wine offre l'interfaccia \ di Windows sopra Linux]],
  [#pila(([App con istruzioni x86], white), ([*Rosetta*], rgb("#fff3c4")), ([macOS], rgb("#eef4ff")), ([ARM], luma(230)), larghezza: 2.8cm)
   #v-verde \ #text(8pt)[Rosetta traduce \ le istruzioni x86 in ARM]],
))

Per costruire sistemi così complessi si usano tre principi:

- *Gerarchia*: il sistema è diviso in livelli (sopra).
- *Modularità*: ogni livello è fatto di moduli con un compito preciso.
- *Regolarità*: lo stesso modulo si riusa tante volte.

#grid(columns: (1fr, 1.4fr), gutter: 1.5em, align: horizon,
figura(box(stroke: 0.6pt, inset: 10pt)[
  #text(8pt)[livello i] \
  #stack(dir: ltr, spacing: 8pt, ..("+", "−", "×").map(o => box(stroke: 0.8pt, inset: 8pt, fill: rgb("#eef4ff"))[*#o*]))
], [Modularità: un livello fatto di moduli]),
figura(canvas(length: 1cm, {
  import draw: *
  let cifre = ((1, 7, 9), (2, 8, 1), (3, 9, 2)) // (a, b, somma) per centinaia, decine, unità
  for (k, (a, b, s)) in cifre.enumerate() {
    let x = k * 2.2
    rect((x, 0), (x + 1.2, 0.8), fill: rgb("#eef4ff"))
    content((x + 0.6, 0.4), [FA])
    content((x + 0.3, 1.5), [#a]); line((x + 0.3, 1.25), (x + 0.3, 0.85), mark: (end: "stealth"))
    content((x + 0.9, 1.5), [#b]); line((x + 0.9, 1.25), (x + 0.9, 0.85), mark: (end: "stealth"))
    line((x + 0.6, -0.05), (x + 0.6, -0.5), mark: (end: "stealth")); content((x + 0.6, -0.8), strong[#s])
  }
  // riporti da destra a sinistra
  content((6.9, 0.4), text(9pt)[0]); line((6.75, 0.4), (5.65, 0.4), mark: (end: "stealth"))
  content((5.1, 0.65), text(8pt, fill: red)[1]); line((4.4, 0.4), (3.45, 0.4), mark: (end: "stealth"))
  content((2.9, 0.65), text(8pt, fill: red)[1]); line((2.2, 0.4), (1.25, 0.4), mark: (end: "stealth"))
  line((-0.05, 0.4), (-0.6, 0.4), mark: (end: "stealth")); content((-0.85, 0.4), text(9pt)[0])
}), [Regolarità: 123 + 789 = 912 con tre FA uguali in cascata. \ Ogni FA somma una cifra e passa il riporto (in rosso) a sinistra]),
)

Stesso modulo `+`, due modi di sommare 8 numeri:

#grid(columns: (1fr, 1.3fr), gutter: 1.5em, align: horizon,
[
  ```c
  sum = 0;
  for (i = 0; i < n; i++)
      sum = sum + x[i];
  ```
  7 somme *una dopo l'altra*: ognuna aspetta il risultato della precedente, quindi 7 passi.
],
figura(canvas(length: 0.75cm, {
  import draw: *
  let nodo(p) = { circle(p, radius: 0.32, fill: rgb("#eef4ff")); content(p, [+]) }
  for k in range(8) { content((k, 0), text(9pt)[$x_#(k + 1)$]) }
  let l1 = range(4).map(k => (2 * k + 0.5, -1.2))
  let l2 = ((1.5, -2.4), (5.5, -2.4))
  let radice = (3.5, -3.6)
  for (k, p) in l1.enumerate() { line((2 * k, -0.3), p); line((2 * k + 1, -0.3), p) }
  for (k, p) in l2.enumerate() { line(l1.at(2 * k), p); line(l1.at(2 * k + 1), p) }
  line(l2.at(0), radice); line(l2.at(1), radice)
  for p in l1 + l2 + (radice,) { nodo(p) }
  content((8.6, -1.2), text(8pt)[passo 1]); content((8.6, -2.4), text(8pt)[passo 2]); content((8.6, -3.6), text(8pt)[passo 3])
}), [Ad albero: le somme dello stesso livello sono indipendenti, quindi si possono fare insieme (con 4 sommatori): le stesse 7 somme in 3 passi]),
)

== Numeri binari

I circuiti digitali lavorano in *binario*: ogni segnale vale 0 o 1.

In un sistema posizionale *conta l'ordine delle cifre*: la stessa cifra vale di più quanto più è a sinistra. Ogni posizione ha un peso.

#align(center, table(columns: 5, align: center,
  [], [], [], [], [],
  [decimale], [$10^3 = 1000$], [$10^2 = 100$], [$10^1 = 10$], [$10^0 = 1$],
  [binario], [$2^3 = 8$], [$2^2 = 4$], [$2^1 = 2$], [$2^0 = 1$],
))

Esempio: $13_10 != 31_10$ e $10_2 != 01_2$ (il numero piccolo in basso è la base).

Per passare *da binario a decimale* sommo i pesi delle posizioni dove c'è 1: $1100_2 = 8 + 4 = 12$.

Per passare *da decimale a binario* divido per 2 finché arrivo a 1, poi leggo i resti *dal basso verso l'alto*. Il resto della divisione per 2 dice se il numero è pari o dispari, cioè l'ultima cifra binaria; dividendo, "tolgo" quella cifra e passo alla successiva. Per questo le cifre escono da destra a sinistra.

#align(center, grid(columns: 2, gutter: 3em,
  table(columns: 3, align: center,
    [n], [: 2], [resto],
    [12], [6], [0],
    [6], [3], [0],
    [3], [1], [1],
    [1], [], [1 ↑],
  ) + align(center)[$12 = 1100_2$],
  table(columns: 3, align: center,
    [n], [: 2], [resto],
    [7], [3], [1],
    [3], [1], [1],
    [1], [], [1 ↑],
  ) + align(center)[$7 = 111_2$],
))

Somma e prodotto in binario si fanno come in decimale, ma $1 + 1 = 10_2$: scrivo 0 e riporto 1.

#align(center, grid(columns: 3, gutter: 3em, align: bottom,
  [#conto(sopra: ("8421",), "1010", "0100", "1110") \ #text(9pt)[10 + 4 = 14 (pesi in grigio)]],
  [#conto(sopra: ("111 ",), "0111", "0001", "1000") \ #text(9pt)[7 + 1 = 8 (riporti in grigio)]],
))

Nel prodotto in colonna la cifra del moltiplicatore è 0 o 1, quindi ogni riga è tutta zeri oppure il numero stesso, spostata di un posto a sinistra (il · segna il posto lasciato vuoto).

#align(center, grid(columns: 2, gutter: 4em, align: bottom,
  [#conto(op: "×", "12", "34", " 48", "36·", "408") \ #text(9pt)[in decimale]],
  [#conto(op: "×", "1010", "0100", "0000", "0000·", "1010··", "0000···", "0101000") \ #text(9pt)[10 × 4 = 40 = 32 + 8]],
))

Per i *numeri negativi* il modo più semplice è *modulo e segno*: il primo bit è il *segno* (0 = +, 1 = −), gli altri sono il *valore assoluto*.

#align(center, table(columns: 5, align: center, inset: 8pt,
  table.cell(fill: rgb("#fde2e2"))[*1*], [1], [1], [0], [0],
  table.cell(stroke: none)[#text(8pt)[segno]], table.cell(colspan: 4, stroke: none)[#text(8pt)[valore assoluto = 12]],
))
#align(center)[$-12$ in modulo e segno]

Per sommare A e B bisogna prima guardare i segni ($S$ = segno, $V$ = valore assoluto):

#align(center, table(columns: 2,
  [Caso], [Risultato],
  [$S_A = S_B$], [segno $S_A$, valore $V_A + V_B$],
  [$S_A != S_B$ e $V_A > V_B$], [segno $S_A$, valore $V_A - V_B$],
  [altrimenti], [segno $S_B$, valore $V_B - V_A$],
))

Esempi: $+12 + 12 = +24$, #h(0.5em) $-12 + (-12) = -24$, #h(0.5em) $-12 + 7 = -5$ (segni diversi: faccio $12 - 7$ e tengo il segno del più grande).

#nota[Servono confronti e sottrazioni: il circuito che somma diventa complicato. Il complemento a 2 risolve questo problema.]

Si usa quindi il *complemento a 2*: i positivi si scrivono come sempre, e per passare da $n$ a $-n$ si negano tutti i bit (0 ↔ 1) e si somma 1:

#align(center, stack(dir: ltr, spacing: 0.8em,
  box(stroke: 0.6pt, inset: 6pt)[$n$ in binario], align(horizon)[→],
  box(stroke: 0.6pt, inset: 6pt, fill: rgb("#eef4ff"))[nego tutti i bit], align(horizon)[→],
  box(stroke: 0.6pt, inset: 6pt, fill: rgb("#eef4ff"))[$+1$], align(horizon)[→],
  box(stroke: 0.6pt, inset: 6pt)[$-n$],
))

Vale anche al contrario: rifacendo "nego + 1" su $-n$ torno a $n$. Così, se un risultato comincia con 1 (è negativo), capisco quanto vale.

Il vantaggio: *la somma si fa come una somma normale*, senza guardare i segni.

#block(sticky: true)[Esempio: $-12 + 7$ su 5 bit.]

#align(center, grid(columns: 3, gutter: 2.5em, align: bottom,
  [#passi(("12", "01100"), ("nego", "10011"), ("+1", "10100")) \ #text(9pt)[−12]],
  [#conto("10100", "00111", "11011") \ #text(9pt)[−12 + 7]],
  [#passi(("somma", "11011"), ("nego", "00100"), ("+1", "00101")) \ #text(9pt)[inizia per 1, è negativo: \ vale −5 ✓]],
))

#block(sticky: true)[Esempio: $-5 + (-3)$ su 6 bit.]

#align(center, grid(columns: 4, gutter: 2em, align: bottom,
  [#passi(("5", "000101"), ("nego", "111010"), ("+1", "111011")) \ #text(9pt)[−5]],
  [#passi(("3", "000011"), ("nego", "111100"), ("+1", "111101")) \ #text(9pt)[−3]],
  [#conto(sopra: ("11111 ",), "111011", "111101", "111000") \ #text(9pt)[esce un riporto 1 \ oltre i 6 bit: si butta]],
  [#passi(("somma", "111000"), ("nego", "000111"), ("+1", "001000")) \ #text(9pt)[vale 8, quindi \ il risultato è −8 ✓]],
))

#nota[Nell'esempio −5 + (−3) esce un riporto oltre i 6 bit e il risultato è giusto lo stesso: *il riporto in uscita non è un errore*. L'errore vero è l'overflow, qui sotto.]

Quanti numeri ci stanno in $n$ bit? Ogni bit raddoppia le combinazioni: $2 dot 2 dot 2 dots.c = 2^n$. Con 8 bit sono $2^8 = 256$ combinazioni, e il bit in posizione $i$ (contando da destra, da 0) pesa $2^i$.

#block(breakable: false, align(center, grid(columns: 2, gutter: 3em, align: horizon,
  figura(table(columns: 8, align: center, inset: 5pt,
    ..range(8).rev().map(i => text(8pt)[$2^#i$]),
    ..range(8).map(_ => [ ]),
  ), [8 bit: sopra ogni casella il suo peso]),
  figura(table(columns: 2, align: (right, right), inset: 4pt,
    [binario], [valore],
    ..(0, 1, 2, 3, 4).map(v => (mono(c2(v, 8)), [#v])).flatten(),
    [⋮], [⋮],
    mono(c2(255, 8)), [255],
  ), [Le 256 combinazioni, dalla più piccola alla più grande]),
)))

Le 256 combinazioni si possono usare in due modi:

#align(center, table(columns: 3, align: center,
  [con $n$ bit], [intervallo], [8 bit],
  [interi *senza segno* (solo +)], [$0 dots 2^n - 1$], [$0 dots 255$],
  [*relativi* (+ e −) in complemento a 2], [$-2^(n-1) dots +2^(n-1) - 1$], [$-128 dots +127$],
))

In complemento a 2 metà delle combinazioni va ai negativi e metà a zero e positivi: per questo c'è un negativo in più ($-128$) e i positivi si fermano a $+127$.

Un numero in complemento a 2 si legge così: *il bit più a sinistra pesa $-2^(n-1)$*, gli altri pesano $+2^i$ come sempre. Il segno è già dentro i pesi: per questo basta la somma normale.

#align(center, grid(columns: 2, gutter: 3em, align: horizon,
  table(columns: 8, align: center, inset: 5pt,
    text(8pt, fill: red)[$-128$], ..range(7).rev().map(i => text(8pt)[$2^#i$]),
    ..range(8).map(_ => [ ]),
  ),
  [$1111 space 1101 = -128 + 64 + 32 + 16 + 8 + 4 + 1 = -3$],
))

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 3em, align: horizon,
  table(columns: 2, align: (right, left), inset: 4pt,
    [valore], [8 bit],
    ..(3, 2, 1, 0, -1, -2, -3).map(v => ([#v], mono(c2(v, 8)))).flatten(),
    [⋮], [⋮],
    [−128], mono(c2(-128, 8)),
  ),
  [
    - Tutti i negativi cominciano per 1, zero e positivi per 0.
    - $-1$ è tutti 1: $0000 space 0001$ → nego $1111 space 1110$ → $+1$ → $1111 space 1111$.
    - $-128$ non ha l'opposto: facendo "nego + 1" torna se stesso, perché $+128$ non ci sta in 8 bit.
    #align(center, passi(("-128", "1000 0000"), ("nego", "0111 1111"), ("+1", "1000 0000")))
  ],
))

#nota[In *modulo e segno* l'intervallo è $-(2^(n-1) - 1) dots +(2^(n-1) - 1)$ e lo zero ha *due* rappresentazioni, $+0 = 0000 space 0000$ e $-0 = 1000 space 0000$. Anche un semplice `if (x == 0)` deve controllarle tutte e due: un altro motivo per cui si usa il complemento a 2.]

Sommando due numeri di $n$ bit il risultato può aver bisogno di $n + 1$ bit, ma il circuito ne ha solo $n$. Quando il risultato esce dall'intervallo rappresentabile si ha *overflow* (traboccamento).

Esempi su 3 bit, dove il complemento a 2 va da $-4$ a $+3$:

#align(center, table(columns: 8, align: center, inset: 4pt,
  ..range(-4, 4).map(v => [#v]),
  ..range(-4, 4).map(v => mono(c2(v, 3))),
))

#align(center, grid(columns: 2, gutter: 4em, align: bottom,
  [#conto(sopra: ("1  ",), "010", "010", "100") \ #text(9pt)[2 + 2 = 4, ma 100 vale −4 ✗]],
  [#conto("101", "110", "(1)011") \ #text(9pt)[−3 + (−2) = −5, ma 011 vale +3 ✗]],
))

#align(center, box(stroke: 1pt + red, inset: 10pt, radius: 4pt)[*Regola*: operandi con lo *stesso segno* e risultato con *segno diverso* ⟹ *overflow*.])

Con segni diversi l'overflow non può mai capitare: il risultato sta sempre fra i due operandi.

Il complemento a 2 permette di fare anche la *sottrazione con lo stesso sommatore*: $a - b = a + (-b)$. Il circuito è fra i componenti delle reti logiche.

== Basi, numeri reali e caratteri

Un sistema posizionale in *base B* usa le cifre da $0$ a $B - 1$, e la cifra in posizione $i$ pesa $B^i$.

#align(center, table(columns: 3, align: (center, left, left),
  [base], [cifre], [nota],
  [$B = 10$], [$0, 1, dots, 9$], [],
  [$B = 2$], [$0, 1$], [],
  [$B = 8$], [$0, 1, dots, 7$], [una cifra = 3 bit],
  [$B = 16$], [$0, dots, 9, A, B, C, D, E, F$], [una cifra = 4 bit (*nibble*); $A = 10, dots, F = 15$],
))

In base 16 i pesi sono $16^2 = 256$, $16^1 = 16$, $16^0 = 1$. L'esadecimale si usa perché da binario si passa *senza conti*: $16 = 2^4$, quindi una cifra esadecimale corrisponde esattamente a 4 bit. Divido i bit in gruppi di 4 partendo da destra e scrivo ogni gruppo come una cifra. Il prefisso `0x` indica un numero esadecimale.

#align(center, grid(columns: 2, gutter: 2em, align: horizon,
canvas(length: 0.5cm, {
  import draw: *
  for (k, b) in "01101101".clusters().enumerate() {
    let x = k + if k >= 4 { 0.6 } else { 0 }
    content((x, 0), mono(b))
    content((x, -0.8), text(6pt, fill: gray)[#calc.pow(2, 7 - k)])
  }
  line((-0.3, 0.5), (-0.3, 0.8), (3.3, 0.8), (3.3, 0.5)); line((3.9, 0.5), (3.9, 0.8), (7.9, 0.8), (7.9, 0.5))
  content((1.5, 1.4), [*6*]); content((5.9, 1.4), [*D*])
}),
[$0110 space 1101 = mono("0x6D") = 64 + 32 + 8 + 4 + 1 = 109$],
))

Esempio: $-3$ su 16 bit.

#align(center, grid(columns: 2, gutter: 3em, align: horizon,
  passi(("3", c2(3, 16)), ("nego", "1111 1111 1111 1100"), ("+1", c2(-3, 16))),
  [ogni gruppo 1111 è una F, 1101 è D: \ $-3 = mono("0xFFFD")$],
))

Per i *numeri con la virgola* la notazione posizionale continua a destra della virgola con esponenti negativi:

$ "123,45" = 1 times 10^2 + 2 times 10^1 + 3 times 10^0 + 4 times 10^(-1) + 5 times 10^(-2) $

Tenendo la virgola in una posizione fissa, per sommare $"123,45" + "17,9"$ bisogna prima allinearla ($"017,90"$). Si usa invece la *virgola mobile* (*floating point*): cifre ed esponente separati, come nella notazione `mmmEn` = $"mmm" times 10^n$.

#align(center, grid(columns: 2, align: left, column-gutter: 1em, row-gutter: 0.6em,
  [`12345E-2`], [$= "123,45"$ #h(1em) (la virgola si sposta di 2 a sinistra)],
  [`123E2`], [$= 12300$],
))

Il numero si scrive come $plus.minus "0,mantissa" times 10^E$ e si salvano tre campi, in 32 o 64 bit:

#block(breakable: false, align(center, grid(columns: 2, gutter: 3em, align: horizon,
  table(columns: (0.8cm, 2cm, 5cm), align: center, inset: 6pt,
    table.cell(fill: rgb("#fde2e2"))[S], table.cell(fill: rgb("#fff3c4"))[E], table.cell(fill: rgb("#eef4ff"))[mantissa],
    table.cell(stroke: none, text(8pt)[segno]), table.cell(stroke: none, text(8pt)[esponente]), table.cell(stroke: none, text(8pt)[valore $"0,xxxx"$]),
  ),
  [$"123,45" = +"0,12345" times 10^3$ \ S = 0, #h(0.3em) E = 3, #h(0.3em) mantissa = 12345],
)))

L'esponente può essere negativo: con 8 bit ha 256 valori, da $-128$ a $+127$. Così con pochi bit si scrivono numeri molto grandi e molto piccoli. Si chiama virgola *mobile* proprio perché cambiando l'esponente la virgola si sposta.

Anche i *caratteri* sono numeri. Il codice *ASCII* assegna un numero a ogni carattere, con 7 o 8 bit per carattere (cioè 128 o 256 caratteri); deve rappresentare:
- le 26 lettere, maiuscole e minuscole (e quelle accentate);
- le 10 cifre e la punteggiatura;
- i caratteri speciali: `CR` (ritorno a inizio riga), `LF` (riga nuova), `TAB`, `DEL`, ...

#align(center, table(columns: 6, align: center,
  [carattere], [A], [B], [a], [c], [m],
  [codice], [65], [66], [97], [99], [109],
))

Le lettere hanno codici in ordine alfabetico, quindi confrontare due stringhe (in C `char *s1, *s2`) vuol dire confrontare i codici carattere per carattere: "ciao" viene prima di "mondo" perché `c` = 99 < `m` = 109.

= Reti logiche

== Porte logiche e tabelle di verità

Una *rete combinatoria* è un circuito che calcola una funzione: l'uscita dipende solo dal valore degli ingressi in quel momento.

I circuiti digitali lavorano su $\{0, 1\}$ con tre operazioni di base, le *porte logiche*. Gli ingressi entrano da sinistra, l'uscita esce a destra.

#let simbolo(disegno) = canvas(length: 0.8cm, {
  import draw: *
  line((-0.5, 0.25), (0, 0.25)); line((-0.5, -0.25), (0, -0.25))
  disegno
  line((0.9, 0), (1.4, 0))
})
#align(center, grid(columns: 3, gutter: 3em, align: center + top,
  [#simbolo(porta-and((0, 0))) \ *AND* \ #tvb(($x$, $y$), ($z$, b => b.at(0) * b.at(1)))],
  [#simbolo(porta-or((0, 0))) \ *OR* \ #tvb(($x$, $y$), ($z$, b => calc.max(b.at(0), b.at(1))))],
  [#canvas(length: 0.8cm, { import draw: *; line((-0.5, 0), (0, 0)); porta-not((0, 0)); line((0.88, 0), (1.4, 0)) }) \ *NOT* \ #tvb(($x$,), ($z$, b => 1 - b.at(0)))],
))

AND vale 1 solo se *tutti* gli ingressi valgono 1; OR vale 1 se *almeno uno* vale 1; NOT inverte. Nelle formule si usa una notazione più corta, come nell'algebra:

#align(center, table(columns: 4, align: center,
  [], [AND], [OR], [NOT],
  [si scrive], [$x dot y$ oppure $x y$ (prodotto)], [$x + y$ (somma)], [$overline(x)$],
))

Somiglia davvero ad aritmetica: su 0 e 1, AND è il prodotto. OR è la somma, tranne $1 + 1$ che fa 1. Alcune proprietà:

#align(center, grid(columns: 2, align: left, column-gutter: 1.5em, row-gutter: 0.8em,
  [*associativa*], [$(x "AND" y) "AND" z equiv x "AND" (y "AND" z)$],
  [*commutativa*], [$x "AND" y equiv y "AND" x$],
  [elemento neutro], [$x "AND" 1 equiv x$ #h(2em) $x "OR" 0 equiv x$],
  [elemento assorbente], [$x "AND" 0 equiv 0$ #h(2em) $x "OR" 1 equiv 1$],
))

#video("09", "24:21", "29:54")Servono davvero tre tipi di porte? No: ne basta uno solo, come avere un unico mattoncino Lego al posto di tre, che si progetta una volta e poi si collega. Questo mattoncino è la *NAND*: un AND con l'uscita negata (il pallino in fondo, come nel NOT).

#let nand(a, b) = 1 - a * b
#align(center, grid(columns: 2, gutter: 3em, align: horizon,
  align(center)[#canvas(length: 0.8cm, { import draw: *; line((-0.5, 0.25), (0, 0.25)); line((-0.5, -0.25), (0, -0.25)); porta-nand((0, 0)); line((1.06, 0), (1.5, 0)) }) \ #tvb(($x$, $y$), ([NAND], b => nand(..b)))],
  align(left)[
    - *NOT*: $"NAND"(x, x)$, perché $x "AND" x = x$ e poi viene negato.
    - *AND*: una NAND seguita da un NOT, che toglie la negazione.
    - *OR*: per la legge di *De Morgan* $x + y = overline(overline(x) dot overline(y))$, cioè nego i due ingressi e li mando in una NAND.
  ],
))

#let filo(x) = { import draw: *; line((x, 0.15), (x + 0.5, 0.15)); line((x, -0.15), (x + 0.5, -0.15)) }
#block(breakable: false, align(center, grid(columns: 3, gutter: 3em, align: center + bottom,
  [#canvas(length: 0.8cm, { import draw: *
    line((-0.8, 0), (-0.3, 0)); nand-not((0, 0)); line((0.76, 0), (1.3, 0)) }) \ #text(9pt)[NOT: 1 NAND]],
  [#canvas(length: 0.8cm, { import draw: *
    filo(-0.5); porta-nand((0, 0), h: 0.6); line((0.76, 0), (1.2, 0)); nand-not((1.5, 0)); line((2.26, 0), (2.8, 0)) }) \ #text(9pt)[AND: 2 NAND]],
  [#canvas(length: 0.8cm, { import draw: *
    for y in (0.5, -0.5) {
      line((-0.8, y), (-0.3, y)); nand-not((0, y))
      line((0.76, y), (1.2, y), (1.2, y * 0.3), (1.6, y * 0.3))
    }
    porta-nand((1.6, 0), h: 0.6); line((2.36, 0), (2.9, 0)) }) \ #text(9pt)[OR: 3 NAND]],
)))

Il prezzo: si risparmia lavoro di progettazione, ma non spazio sul chip, perché per ogni AND o OR servono più NAND.

Per costruire una rete da zero si seguono cinque passi, il *procedimento standard*:

#align(center, text(9pt, stack(dir: ltr, spacing: 0.5em,
  box(stroke: 0.6pt, inset: 7pt)[1. descrizione \ a parole], align(horizon)[→],
  box(stroke: 0.6pt, inset: 7pt, fill: azzurro)[2. tabella \ di verità], align(horizon)[→],
  box(stroke: 0.6pt, inset: 7pt)[3. *somma di prodotti* \ #text(8pt)[OR di tanti AND]], align(horizon)[→],
  box(stroke: 0.6pt, inset: 7pt, fill: rgb("#fff3c4"))[4. rete \ di porte], align(horizon)[→],
  box(stroke: 0.6pt, inset: 7pt)[5. tempo di \ stabilizzazione],
)))

La tabella di verità è la funzione descritta caso per caso: per ogni combinazione di ingressi dice quanto vale l'uscita.

Esempio: il *MUX*. A parole: _scegli fra due ingressi $x$ e $y$ a seconda di un ingresso di controllo $c$_.

```c
if (c == 0) z = x;
else        z = y;
```

Dalla descrizione si ricava la tabella di verità. Poi, per ogni riga dove $z = 1$, scrivo un prodotto (AND) che vale 1 *solo* in quella riga: la variabile così com'è se vale 1, negata ($overline(x)$) se vale 0.

#let minterm(b) = {
  let v = ($x$, $y$, $c$)
  prodotto(v, b)
}
#let muxf(b) = if b.at(2) == 0 { b.at(0) } else { b.at(1) }
#align(center, grid(columns: 2, gutter: 3em, align: horizon,
  tvb(($x$, $y$, $c$), ($z$, muxf), ([prodotto], b => if muxf(b) == 1 { text(fill: blu, minterm(b)) } else [])),
  align(left)[
    Le righe con $z = 1$ sono unite da un OR. Ogni prodotto vale 1 solo nella sua riga, quindi l'OR vale 1 esattamente nelle righe scelte.
    $ z = #sdp(($x$, $y$, $c$), muxf) $
    Per esempio $overline(x) y c$ = NOT($x$) AND $y$ AND $c$: vale 1 solo per $x = 0, y = 1, c = 1$.
  ],
))

Ogni prodotto diventa una porta AND a tre ingressi (il pallino sull'ingresso è un NOT), e le quattro uscite entrano in una OR:

#align(center, grid(columns: 2, gutter: 3em, align: horizon,
figura(rete-sp(($x$, $y$, $c$), ((0, 1, 1), (1, 0, 0), (1, 1, 0), (1, 1, 1))), [Il MUX come rete di porte]),
align(left)[Nei disegni il MUX si abbrevia con un trapezio: in alto i due ingressi, ognuno col valore di $c$ che lo sceglie; a sinistra il controllo; in basso l'uscita.
  #align(center, mux)],
))

== Tempo di stabilizzazione

#video("07", "01:15", "06:41")Una porta non risponde subito. Da quando gli ingressi hanno il loro valore (istante $t_0$) a quando l'uscita è quella giusta ($t_1$) passa del tempo, e nel frattempo l'uscita può valere qualunque cosa. È il *tempo di stabilizzazione* (o ritardo) della rete.

#figura(canvas(length: 0.8cm, {
  import draw: *
  let (t0, t1, fine) = (2, 4.5, 8)
  let segnale(nome, y, da, v) = {
    content((-0.5, y + 0.2), nome)
    rect((0, y), (da, y + 0.4), fill: luma(225), stroke: none)
    content((da / 2, y + 0.2), text(8pt, fill: luma(110))[?])
    line((da, y + 0.4 * v), (fine, y + 0.4 * v), stroke: 1.2pt + blu)
    content((fine + 0.3, y + 0.2), [#v])
  }
  segnale($x$, 0, t0, 1); segnale($y$, -0.8, t0, 0); segnale($c$, -1.6, t0, 1); segnale($z$, -2.4, t1, 0)
  for (t, n) in ((t0, $t_0$), (t1, $t_1$)) {
    line((t, 0.7), (t, -2.6), stroke: (dash: "dashed")); content((t, 1), n)
  }
  line((t0, -3), (t1, -3), mark: (start: "stealth", end: "stealth"))
  content(((t0 + t1) / 2, -3.4), text(9pt)[tempo di stabilizzazione])
}), [Il MUX con $c = 1$ fa passare $y = 0$. In grigio i tratti dove il valore non è ancora certo: \ gli ingressi sono pronti da $t_0$, ma $z$ è affidabile solo da $t_1$ in poi])

#video("07", "06:41", "17:28")Il ritardo di una porta dipende da quanti ingressi ha: resta quasi uguale fino a una certa soglia, poi cresce in fretta (grafico a sinistra). Nel corso si usa questa convenzione: fino a 8 ingressi, una porta AND o OR ha sempre lo stesso ritardo, che si chiama $Delta t$ ("delta t": la lettera greca $Delta$ indica un intervallo, qui di tempo). I tempi delle reti si contano in $Delta t$: $2 Delta t$ vuol dire due porte una dopo l'altra.

#align(center, grid(columns: 2, gutter: 3em, align: horizon,
canvas(length: 0.7cm, {
  import draw: *
  line((0, 0), (5, 0), mark: (end: "stealth")); line((0, 0), (0, 3), mark: (end: "stealth"))
  content((2.5, -1), text(8pt)[numero di ingressi]); content((0, 3.4), text(8pt)[ritardo])
  line((0, 0.5), (2.8, 0.5), stroke: 1.2pt + blu)
  bezier((2.8, 0.5), (4.3, 3), (3.8, 0.5), stroke: 1.2pt + blu)
  line((2.8, 0), (2.8, 0.5), stroke: (dash: "dashed")); content((2.8, -0.35), text(8pt)[8])
  content((-0.5, 0.5), text(8pt)[$Delta t$])
}),
box(stroke: 1pt + red, inset: 10pt, radius: 4pt, align(left)[
  - AND e OR *fino a 8 ingressi*: ritardo $Delta t$
  - NOT: ritardo *0*
]),
))

Il NOT non costa perché il segnale negato è già pronto dentro la porta che lo produce: basta prenderlo da un altro punto del circuito.

Con le porte da 8 si fanno anche quelle più piccole: gli ingressi che avanzano si collegano al valore che non cambia il risultato, 1 per l'AND e 0 per l'OR. Per più di 8 ingressi si collegano più porte *ad albero*, e ogni livello dell'albero costa $Delta t$.

#align(center, grid(columns: 3, gutter: 2.5em, align: center + bottom,
  [#canvas(length: 0.6cm, {
    import draw: *
    porta-and((0, 0), h: 3.4)
    for (k, t) in ($x$, $y$, [1], [1], [1], [1], [1], [1]).enumerate() {
      let y = 1.47 - k * 0.42
      line((-0.7, y), (0, y)); content((-1, y), text(7pt, fill: if k < 2 { black } else { red }, t))
    }
    line((3.4, 0), (4, 0))
  }) \ #text(9pt)[AND da 2 con una porta da 8: \ sei ingressi fissi a 1]],
  [#canvas(length: 0.6cm, {
    import draw: *
    let liv = ((0, 1.2, 2.4, 3.6), (0.6, 3.0), (1.8,))
    for (l, ys) in liv.enumerate() {
      for y in ys {
        porta-and((l * 2, -y), h: 0.7)
        if l == 0 { line((-0.5, -y + 0.2), (0, -y + 0.2)); line((-0.5, -y - 0.2), (0, -y - 0.2)) }
        if l < 2 {
          let yn = liv.at(l + 1).sorted(key: v => calc.abs(v - y)).first()
          let yi = -yn + if y < yn { 0.2 } else { -0.2 }
          line((l * 2 + 0.7, -y), (l * 2 + 1.3, -y), (l * 2 + 1.3, yi), (l * 2 + 2, yi))
        } else { line((l * 2 + 0.7, -y), (l * 2 + 1.4, -y)) }
      }
    }
  }) \ #text(9pt)[AND da 8 con porte da 2: \ $log_2 8 = 3$ livelli]],
  [#canvas(length: 0.6cm, {
    import draw: *
    for (k, y) in (0, 1.2, 3.6).enumerate() {
      porta-and((0, -y), h: 0.7)
      line((-0.9, -y), (0, -y)); bus((-0.5, -y), [8])
      let yi = -1.8 + 0.5 - k * 0.5
      line((0.7, -y), (1.3, -y), (1.3, yi), (2, yi))
    }
    content((0.35, -2.3), [⋮])
    porta-and((2, -1.8), h: 1.6)
    line((3.6, -1.8), (4.3, -1.8))
  }) \ #text(9pt)[AND da 64 con porte da 8: \ $log_8 64 = 2$ livelli]],
))

In generale, una porta da $n$ ingressi fatta con porte da $k$ ingressi richiede $ceil(log_k n)$ livelli ($ceil(dot)$ = arrotondato per eccesso): la base è il numero di ingressi di una porta, l'argomento il numero di ingressi totali.

Il tempo di stabilizzazione di una rete si conta sui *livelli* di AND e OR che il segnale attraversa: le porte dello stesso livello lavorano insieme e costano un solo $Delta t$, i livelli uno dopo l'altro si sommano. Il MUX ha un livello di AND e uno di OR: $2 Delta t$. Vale per ogni somma di prodotti, finché termini e variabili non sono più di 8.

#video("07", "17:48", "37:59")Una rete si può costruire in due modi: da zero con i cinque passi, oppure *componendo* reti già fatte. Esempio: un MUX che sceglie fra *quattro* ingressi con due bit di controllo $c_0 c_1$ (qui $c_0$ è quello più a sinistra). Il simbolo è quello del MUX a due, con quattro ingressi: sopra ognuno c'è il valore di $c_0 c_1$ che lo sceglie (00 sceglie $x_0$, 11 sceglie $x_3$). La barretta col 2 vuol dire che su quel filo passano 2 bit, $c_0$ e $c_1$.

#let tab-mux4 = {
  let righe = range(4).map(c => (0, 1).map(v => (
    [#calc.quo(c, 2)], [#calc.rem(c, 2)], ..range(4).map(i => if i == c [#v] else [−]),
    if v == 1 { text(fill: blu, weight: "bold")[1] } else [0],
  ))).flatten()
  table(columns: 7, align: center, inset: 5pt,
    stroke: (x, y) => if x == 5 { (right: 1pt) } + if y == 0 { (bottom: 1pt) },
    $c_0$, $c_1$, $x_0$, $x_1$, $x_2$, $x_3$, $z$, ..righe)
}
#block(breakable: false, grid(columns: (auto, auto, 1fr), gutter: 1.5em, align: horizon,
  canvas(length: 0.8cm, {
    import draw: *
    trap((0, 0), w: 3.2, etichette: ("00", "01", "10", "11"))
    for k in range(4) { let x = 3.2 * (k + 0.5) / 4; content((x, 1), $x_#k$); fr((x, 0.75), (x, 0)) }
    fr((-1.1, -0.35), (0.15, -0.35)); content((-1.7, -0.35), $c_0 c_1$); bus((-0.75, -0.35), [2])
    fr((1.6, -0.7), (1.6, -1.4)); content((1.6, -1.7), $z$)
  }),
  tab-mux4,
  [*Da zero.* Gli ingressi sono 6: la tabella avrebbe $2^6 = 64$ righe. Si accorcia scrivendo − dove il valore di un ingresso non conta: con controllo 00 conta solo $x_0$. Ogni riga con tre − ne riassume $2^3 = 8$.],
))

$ z = overline(c_0) thin overline(c_1) x_0 + overline(c_0) c_1 x_1 + c_0 overline(c_1) x_2 + c_0 c_1 x_3 $

#let nc = none
#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  figura(rete-sp(($c_0$, $c_1$, $x_0$, $x_1$, $x_2$, $x_3$), ((0, 0, 1, nc, nc, nc), (0, 1, nc, 1, nc, nc), (1, 0, nc, nc, 1, nc), (1, 1, nc, nc, nc, 1))),
    [Da zero: quattro AND e una OR]),
  [Come per il MUX a due, ogni prodotto diventa un AND (qui a sei ingressi, con il pallino sulle variabili negate) e un OR unisce i quattro AND. Il segnale attraversa un livello di AND e uno di OR: $2 Delta t$.],
))

#block(breakable: false, grid(columns: (1fr, auto), gutter: 2em, align: horizon,
  [#video("07", "38:09", "49:14")*Componendo.* Scegliere fra quattro vuol dire scegliere prima dentro ogni coppia, poi fra le due coppie. Bastano tre MUX a due ingressi: il bit meno significativo $c_1$ sceglie dentro le coppie ($x_0$ o $x_1$, $x_2$ o $x_3$), il più significativo $c_0$ sceglie quale coppia esce. Non serve la tabella, ma il segnale attraversa due MUX di fila: i due in alto lavorano insieme ($2 Delta t$), quello in basso deve aspettarli ($+ 2 Delta t$).],
  figura(canvas(length: 0.8cm, {
    import draw: *
    trap((0, 0)); trap((3.6, 0)); trap((1.8, -2))
    for (k, x) in (0.5, 1.5, 4.1, 5.1).enumerate() { content((x, 1), $x_#k$); fr((x, 0.75), (x, 0)) }
    line((1, -0.7), (1, -1.4), (2.3, -1.4)); fr((2.3, -1.4), (2.3, -2))
    line((4.6, -0.7), (4.6, -1.4), (3.3, -1.4)); fr((3.3, -1.4), (3.3, -2))
    fr((2.8, -2.7), (2.8, -3.4)); content((2.8, -3.7), $z$)
    for x in (0, 3.6) { content((x - 0.75, -0.35), text(9pt, $c_1$)); fr((x - 0.5, -0.35), (x + 0.15, -0.35)) }
    content((0.8, -2.35), text(9pt, $c_0$)); fr((1.05, -2.35), (1.95, -2.35))
    content((6.6, -0.35), text(9pt, fill: red)[$2 Delta t$]); content((6.6, -2.35), text(9pt, fill: red)[$+ 2 Delta t$])
  }), [Componendo tre MUX: $4 Delta t$]),
))

#nota[*Regola generale*: la rete progettata da zero ha un tempo di stabilizzazione minore o uguale a quella ottenuta componendo, perché è ottimizzata tutta insieme. Comporre però costa molta meno fatica.]

== Componenti

Il MUX a quattro è venuto fuori collegando MUX a due già pronti, senza ridisegnarne le porte. È l'idea dei *componenti*: le reti che servono spesso si progettano una volta sola, si disegnano come un blocco col loro nome (come il trapezio del MUX) e poi si collegano fra loro. Oltre al MUX ne servono altri quattro: sommatore, demultiplexer, comparatore e codificatore.

#video("08", "00:52", "13:44")Il *sommatore* fa le somme binarie viste nel capitolo 1. Per costruirlo si guarda la somma in colonna (esempio qui sotto): ogni colonna fa la stessa cosa, cioè somma i due bit $x$ e $y$ e il riporto $r$ arrivato da destra, scrive un bit del risultato e passa un riporto alla colonna a sinistra. Basta quindi una rete che fa una colonna, il *full adder* (FA), ripetuta per ogni colonna.

#let ris(b) = calc.rem(b.sum(), 2)
#let rip(b) = if b.sum() >= 2 { 1 } else { 0 }
#let xyr = ($x$, $y$, $r$)
#block(breakable: false, grid(columns: (auto, auto, 1fr), gutter: 2em, align: horizon,
  canvas(length: 0.8cm, {
    import draw: *
    rect((0, 0), (1.4, 0.9), fill: azzurro); content((0.7, 0.45), [FA])
    content((0.35, 1.7), $x$); fr((0.35, 1.45), (0.35, 0.95))
    content((1.05, 1.7), $y$); fr((1.05, 1.45), (1.05, 0.95))
    fr((2.2, 0.45), (1.45, 0.45)); content((2.45, 0.45), $r$)
    fr((-0.05, 0.45), (-0.7, 0.45)); content((-1.1, 0.45), text(9pt)[rip])
    fr((0.7, -0.05), (0.7, -0.6)); content((0.7, -0.9), text(9pt)[ris])
  }),
  tvb(xyr, ([ris], ris), ([rip], rip)),
  [
    #conto(sopra: ("0100",), "0011", "0010", "0101") \
    #text(9pt)[3 + 2: ogni colonna somma due bit e il riporto (in grigio)]
  ],
))

$ "ris" &= #sdp(xyr, ris) \ "rip" &= #sdp(xyr, rip) $

Ogni formula è un OR di quattro prodotti, e ogni prodotto è un AND di tre variabili. Nessuna porta supera gli 8 ingressi (gli AND ne hanno 3, l'OR 4), quindi ognuna costa $Delta t$: il segnale passa per un AND e poi per l'OR, e il FA si stabilizza in $2 Delta t$ (i NOT non costano).

#video("08", "14:41", "17:25")Per sommare numeri di $n$ bit si mettono $n$ FA *in cascata*: il riporto di ognuno entra nel successivo. Da qui in poi i bit si numerano col loro peso: $x_0$ è il meno significativo, $x_(n-1)$ il più significativo.

#figura(catena-fa(($n-1$, none, $1$, $0$)), [Sommatore a $n$ bit: ogni FA aspetta il riporto di quello alla sua destra])

Ogni FA deve aspettare il riporto del precedente, quindi i ritardi *si sommano*: $n dot 2 Delta t = 2 n Delta t$. Con 2 bit sono $4 Delta t$. Se l'ultimo riporto vale 1, la somma di due numeri senza segno non sta in $n$ bit.

#video("08", "19:01", "24:10")Il sommatore fatto con i FA costa $2 n Delta t$. Come per il MUX a quattro, ci si può chiedere se progettarlo *da zero*, con una sola tabella di verità, sarebbe più veloce. Gli ingressi della tabella sono tutti i bit di $x$ e di $y$, e la rete è una somma di prodotti: un livello di AND, poi l'OR. Per il tempo basta sapere quanti ingressi hanno queste porte:

- *AND*: ogni prodotto contiene tutte le variabili, quindi ha tanti ingressi quanti la tabella;
- *OR*: riceve un prodotto per ogni 1 della colonna d'uscita. Gli 1 sono al massimo le righe meno una (se fossero tutti 1 l'uscita varrebbe sempre 1, e la rete non servirebbe).

Con 2 bit, contando anche il riporto iniziale, gli ingressi sono 5 e le righe 32. Gli AND hanno 5 ingressi: 1 livello. L'OR ne ha fino a 31, più di 8, quindi va fatto ad albero: 2 livelli. In tutto $3 Delta t$, contro i $4 Delta t$ dei due FA in cascata.

#nota[Se in una colonna gli 1 sono più della metà, conviene scrivere i termini per gli *0* e negare l'uscita, tanto il NOT non costa: i termini sono al massimo la metà delle righe.]

#video("08", "24:41", "29:35")Il secondo componente, il *demultiplexer*, è il contrario del MUX: un ingresso $x$ e più uscite. Il controllo sceglie su quale uscita mandare $x$; le altre valgono 0. Servirà per scegliere in quale cella di memoria scrivere. Si disegna come un MUX capovolto: sotto ogni uscita c'è il valore di $c$ che la sceglie.

#block(breakable: false, grid(columns: (auto, auto, 1fr), gutter: 2em, align: horizon,
  canvas(length: 0.8cm, {
    import draw: *
    trap((0, 0), demux: true)
    content((1, 1), $x$); fr((1, 0.75), (1, 0))
    content((-1.1, -0.35), $c$); fr((-0.85, -0.35), (0.15, -0.35))
    for (x, t) in ((0.5, $z_1$), (1.5, $z_0$)) { fr((x, -0.7), (x, -1.3)); content((x, -1.6), t) }
  }),
  tvb(($c$, $x$), ($z_1$, b => (1 - b.at(0)) * b.at(1)), ($z_0$, b => b.at(0) * b.at(1))),
  [$ z_1 = overline(c) x #h(2em) z_0 = c x $
   Ogni uscita ha un solo 1, quindi un solo termine: l'OR non serve. C'è solo il livello di AND: $1 Delta t$.],
))

#video("08", "29:42", "35:18")Lo stesso sommatore fa anche la sottrazione: $x - y = x + overline(y) + 1$, perché in complemento a 2 il negativo di $y$ è $overline(y) + 1$. Il bit di controllo *op* fa due cose insieme: comanda il MUX, che con op = 1 fa passare $overline(y)$, ed entra nel sommatore come *riporto iniziale*, cioè il riporto del primo FA. Con op = 1 quel riporto vale 1, ed è il $+ 1$.

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
figura(canvas(length: 0.8cm, {
  import draw: *
  let r = 1.5pt + red
  rect((0, 0), (3, -1), fill: azzurro); content((1.5, -0.5), text(9pt)[sommatore $n$ bit])
  content((0.7, 3.5), $x$); fr((0.7, 3.2), (0.7, 0)); bus((0.7, 2), $n$)
  content((1.85, 3.5), $y$); line((1.85, 3.2), (1.85, 2.8), stroke: r); fr((1.85, 2.8), (1.85, 1.6))
  line((1.85, 2.8), (2.55, 2.8), (2.55, 2.4), stroke: r); circle((1.85, 2.8), radius: 0.05, fill: black)
  circle((2.55, 2.3), radius: 0.1, stroke: r); fr((2.55, 2.2), (2.55, 1.6), stroke: r)
  content((3.15, 2.35), text(7pt)[NOT])
  trap((1.5, 1.6), w: 1.4, h: 0.6)
  fr((2.2, 1), (2.2, 0), stroke: r)
  content((5.6, -0.5), [op]); fr((5.2, -0.5), (3, -0.5))
  content((3.6, -0.62), anchor: "north", text(6pt)[riporto \ iniziale])
  line((4.2, -0.5), (4.2, 1.3)); circle((4.2, -0.5), radius: 0.05, fill: black); fr((4.2, 1.3), (2.75, 1.3))
  fr((1.5, -1), (1.5, -1.8), stroke: r); content((1.5, -2.1), $z$); bus((1.5, -1.4), $n$)
  fr((0, -0.5), (-0.8, -0.5)); content((-1.2, -0.5), text(9pt)[rip])
}), [op = 0 somma, op = 1 sottrazione. \ In rosso il cammino critico]),
[
  Il tempo di stabilizzazione si legge sul *cammino critico* (_critical path_), il percorso più lento dagli ingressi alle uscite:

  #align(center, table(columns: 2, align: (left, right), inset: 5pt,
    [pezzo], [ritardo],
    [NOT], [0],
    [MUX a $n$ bit], [$2 Delta t$],
    [sommatore a $n$ bit], [$2 n Delta t$],
    [*totale*], [$bold(2 (n + 1) Delta t)$],
  ))

  Il MUX a $n$ bit è fatto di $n$ MUX a un bit con lo stesso controllo: lavorano tutti insieme, quindi costa $2 Delta t$ come uno solo.
],
))

#block(breakable: false)[#video("09", "04:50", "15:48")Si torna al sommatore da zero, ora con $n$ bit. La tabella non si scrive più, ma i livelli si contano allo stesso modo, con $ceil(log_8 "ingressi")$ livelli per ogni porta:

#align(center, table(columns: 4, align: (left, center, center, center), inset: 6pt,
  [], [2 bit], [8 bit], [$n$ bit],
  [ingressi], [5 (con il riporto iniziale)], [16], [$2 n$],
  [righe], [$2^5 = 32$], [$2^16 = 65536$], [$2^(2 n)$],
  [livelli di AND], [1 (5 ingressi)], [$ceil(log_8 16) = 2$], [$ceil(log_8 2 n)$],
  [livelli di OR], [2 (fino a 31 ingressi)], [$ceil(16 / 3) = 6$], [$ceil(log_8 2^(2 n)) = ceil((2 n) / 3)$],
  [*da zero*], [$bold(3 Delta t)$], [$bold(8 Delta t)$], [],
  [*con i FA*], [$4 Delta t$], [$16 Delta t$], [$2 n Delta t$],
))]

Per l'ultima colonna: $log_8 a = (log_2 a) / (log_2 8) = (log_2 a) / 3$. Da zero si va più veloci, ma già con 8 bit la tabella ha 65536 righe: nessuno la scrive, e si usano i FA.

#video("09", "16:08", "19:59")Il terzo componente, il *comparatore*, dice se due numeri di $n$ bit sono uguali: uscita 1 se sono uguali, 0 altrimenti. Per un bit la formula è $z = overline(x) thin overline(y) + x y$, che non si semplifica: $2 Delta t$. È il negato dello *XOR* (OR esclusivo), che vale 1 quando i due bit sono diversi. Per $n$ bit si confronta ogni coppia $x_i, y_i$ (nel disegno, ogni riquadro $=$ è il comparatore di un bit) e si fa l'AND di tutte le risposte: basta una coppia diversa per dare 0. Avendo una porta già pronta per il confronto di un bit, con ritardo $Delta t$, si guadagnerebbe solo $1 Delta t$: il livello dell'AND finale resta.

#block(breakable: false, align(center, grid(columns: 2, gutter: 3em, align: horizon,
  tvb(($x$, $y$), ($z$, b => if b.at(0) == b.at(1) { 1 } else { 0 })),
  figura(canvas(length: 0.8cm, {
    import draw: *
    content((0.5, -0.95), [⋮])
    for (k, (i, y)) in (($n-1$, 0), ($1$, -2), ($0$, -3)).enumerate() {
      rect((0, y + 0.35), (1, y - 0.35), fill: azzurro); content((0.5, y), [=])
      fr((-0.7, y + 0.15), (0, y + 0.15)); fr((-0.7, y - 0.15), (0, y - 0.15))
      content((-0.85, y), anchor: "east", text(9pt)[$x_#i, y_#i$])
      let yi = -1.5 + 0.6 - k * 0.6
      line((1, y), (1.7, y), (1.7, yi), (2.4, yi))
    }
    porta-and((2.4, -1.5), h: 1.8)
    fr((4.2, -1.5), (5, -1.5)); content((5.3, -1.5), $z$)
    content((0.5, -3.9), text(8pt, fill: red)[$2 Delta t$]); content((3.3, -3.9), text(8pt, fill: red)[$+ ceil(log_8 n) Delta t$])
  }), [Comparatore a $n$ bit: $(2 + ceil(log_8 n)) Delta t$]),
)))

#video("09", "20:06", "24:14")L'ultimo componente, il *codificatore*, ha $n$ ingressi di cui *esattamente uno* vale 1, e $log_2 n$ uscite che dicono in che posizione sta quell'1 (di solito $2^k$ ingressi e $k$ uscite). Le altre combinazioni di ingressi non sono ammesse, quindi non compaiono nella tabella.

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  table(columns: 6, align: center, inset: 5pt,
    stroke: (x, y) => if x == 3 { (right: 1pt) } + if y == 0 { (bottom: 1pt) },
    $x_3$, $x_2$, $x_1$, $x_0$, $z_1$, $z_0$,
    ..range(4).map(i => (..range(4).rev().map(j => if j == i [1] else [0]), [#calc.quo(i, 2)], [#calc.rem(i, 2)])).flatten()),
  [$ z_1 &= overline(x_3) x_2 overline(x_1) thin overline(x_0) + x_3 overline(x_2) thin overline(x_1) thin overline(x_0) \
     z_0 &= overline(x_3) thin overline(x_2) x_1 overline(x_0) + x_3 overline(x_2) thin overline(x_1) thin overline(x_0) $
   L'ultimo termine è uguale nelle due formule: si calcola una volta sola, 3 AND invece di 4. Il tempo resta $2 Delta t$, ma una porta in meno vuol dire meno spazio e meno consumo.],
))

#nota[All'esame $2 Delta t$ è la risposta giusta solo se i livelli sono due. Conta sempre i livelli: il demultiplexer ne ha uno ($1 Delta t$), due FA in cascata ne hanno quattro ($4 Delta t$).]

#video("09", "31:05", "40:43")Costruire una rete collegando componenti, come il MUX a quattro o il circuito che somma e sottrae, si chiama *approccio strutturale*. Si parte da uno pseudocodice fatto di funzioni e scelte, e ogni pezzo diventa un componente: ogni funzione è una rete, la condizione è una rete con un bit d'uscita, e l'`if` è un MUX comandato da quel bit. Nei disegni $x$ entra in tutti i blocchi; il MUX fa uscire il risultato di F se la condizione vale 1 (qui l'ingresso 1 è a sinistra), quello di G se vale 0.

#align(center, grid(columns: 2, gutter: 4em, align: center + bottom,
  [#se-allora([cond], [F], [G]) \ `if (cond) f(x) else g(x)`],
  [#se-allora([pari], [`x++`], [`x--`]) \ `if (pari(x)) x++ else x--`],
))

Nell'esempio di destra, con $x$ di $n$ bit, i tre blocchi si fanno con quello che c'è già:

- `x++`: un sommatore con ingressi $x$ e la costante 1, riporto iniziale 0. Una costante è un filo fisso a 0 o a 1;
- `x--`: un sommatore con $x$ e la costante 1 negata, riporto iniziale 1: è $x - 1$ fatto come sottrazione;
- `pari(x)`: un numero è pari quando il suo ultimo bit $x_0$ vale 0, quindi basta un NOT su $x_0$, senza calcoli.

== Semplificare le formule

#video("10", "00:29", "07:10")Fra la somma di prodotti e la rete si può *semplificare* la formula con le regole dell'algebra. Si raccoglie, poi si usano $t + overline(t) = 1$ e $x dot 1 = x$:

$ z = x y t + x y overline(t) = x y (t + overline(t)) = x y $

Qui l'OR sparisce: da $2 Delta t$ a $1 Delta t$. Un termine si può anche usare due volte, perché $x + x = x$:

$ z = x y t + x y overline(t) + overline(x) y t = underbrace(x y t + x y overline(t), x y) + underbrace(x y t + overline(x) y t, y t) = x y + y t $

I livelli restano due, quindi il tempo non cambia, ma le porte calano: da 3 AND e 1 OR a 2 AND e 1 OR. Con porte da soli 2 ingressi il guadagno è più grande, perché ogni AND da tre ingressi diventa due porte: da 8 porte a 3. Raccogliendo ancora, $z = y (x + t)$: 2 porte.

Semplificare quindi non sempre fa guadagnare tempo, ma fa risparmiare porte: meno spazio e meno consumo. Allo stesso modo il riporto del FA, usando tre volte il termine $x y r$, diventa:

$ "rip" = y r + x r + x y $

#video("10", "07:13", "36:00")Per vedere cosa raccogliere si usano le *mappe di Karnaugh*: sono la tabella di verità ridisegnata come griglia, con alcune variabili sulle colonne e le altre sulle righe. Le combinazioni sono scritte nell'ordine 00, 01, 11, 10, così fra due celle vicine cambia *un solo bit*. Nell'angolo in alto a sinistra, sopra la diagonale ci sono le variabili delle colonne, sotto quelle delle righe; ogni cella è il valore dell'uscita per quella combinazione (gli 0 in grigio).

#let ka(c, r) = {
  let ((x, y), (a, b)) = (c, r)
  if (x == 0 and a == 0) or (a == 1 and b == 0) or (y == 0 and a == 0 and b == 1) { 1 } else { 0 }
}
#block(breakable: false, align(center, grid(columns: 3, gutter: 2.5em, align: center + bottom,
  [#kmap(($x$,), ($y$,), (c, r) => if c == r { 1 } else { 0 }) \ #text(9pt)[2 variabili: \ il comparatore a un bit]],
  [#kmap(($x$, $y$), ($a$, $b$), ka) \ #text(9pt)[4 variabili: \ una funzione di esempio]],
  [#kmap(($x$, $y$), ($a$, $b$), ka, gruppi: ((0, 0, 2, 2, blu), (0, 3, 4, 1, verde), (-0.35, 1.06, 1.35, 0.88, red), (3, 1.06, 1.35, 0.88, red))) \ #text(9pt)[gli stessi 1 raccolti in tre gruppi]],
)))

Sulla mappa si cercano *gruppi di $2^k$ celle vicine, tutte a 1, a forma di quadrato o rettangolo*. Ogni gruppo diventa un solo termine: ci restano le variabili che nel gruppo non cambiano, le altre $k$ spariscono.

- Gruppo #text(fill: blu)[blu], 4 celle: $y$ e $b$ cambiano, $x$ e $a$ valgono sempre 0. Termine $overline(x) thin overline(a)$.
- Gruppo #text(fill: verde)[verde], 4 celle: tutta la riga $a b = 10$, $x$ e $y$ cambiano. Termine $a overline(b)$.
- Gruppo #text(fill: red)[rosso], 2 celle: la mappa *si richiude sui bordi*, la prima colonna è vicina all'ultima (e la prima riga all'ultima). Cambia solo $x$. Termine $overline(y) thin overline(a) b$.

$ z = overline(x) thin overline(a) + a overline(b) + overline(y) thin overline(a) b $

Un 1 isolato resta un termine con tutte le variabili; su 4 variabili un gruppo da 8 ne lascia una sola. Coprendo tutti gli 1 con il minor numero di gruppi, i più grandi possibili, si ottiene la formula più semplice. I gruppi si chiamano *implicanti*.

#block(sticky: true)[Le due uscite del full adder:]

#let rxy(c, r) = c + r
#block(breakable: false, align(center, grid(columns: 2, gutter: 4em, align: center + bottom,
  [#kmap(($x$, $y$), ($r$,), (c, r) => ris(rxy(c, r))) \ #text(9pt)[ris: gli 1 sono tutti isolati, \ restano i quattro termini da tre variabili]],
  [#kmap(($x$, $y$), ($r$,), (c, r) => rip(rxy(c, r)), gruppi: ((2, 0, 1, 2, blu), (1.06, 1.06, 1.88, 0.88, verde), (2.06, 1.12, 1.88, 0.76, red))) \ #text(9pt)[rip: tre gruppi da 2, \ $"rip" = #text(fill: blu)[$x y$] + #text(fill: verde)[$y r$] + #text(fill: red)[$x r$]$]],
)))

Nel codificatore molte combinazioni di ingressi non sono ammesse: sulla mappa si segnano con −. Non capiteranno mai, quindi si possono contare come 1 quando fa comodo per ingrandire un gruppo.

#let cod(k) = (c, r) => {
  let bit = r + c // x3 x2 x1 x0
  if bit.sum() != 1 [−] else { let pos = 3 - bit.position(v => v == 1); calc.rem(calc.quo(pos, calc.pow(2, k)), 2) }
}
#let x32 = ($x_3$, $x_2$)
#let x10 = ($x_1$, $x_0$)
#block(breakable: false, align(center, grid(columns: 2, gutter: 4em, align: center + bottom,
  [#kmap(x10, x32, cod(1), gruppi: ((0, 2, 4, 2, blu), (0.06, 1.06, 3.88, 1.88, verde))) \ #text(9pt)[$z_1 = #text(fill: blu)[$x_3$] + #text(fill: verde)[$x_2$]$]],
  [#kmap(x10, x32, cod(0), gruppi: ((0, 2, 4, 2, blu), (2.06, 0.06, 1.88, 3.88, red))) \ #text(9pt)[$z_0 = #text(fill: blu)[$x_3$] + #text(fill: red)[$x_1$]$]],
)))

Due gruppi da 8 per ogni uscita: spariscono tre variabili su quattro, e ogni uscita diventa un solo OR.

Con 5 variabili servirebbero due mappe 4 × 4 una sopra l'altra, una per ogni valore della quinta variabile. Per questo oltre le 4 variabili le mappe non si usano.

#video("12", "05:44", "19:21")Due esempi mettono insieme tutto. Il primo, su $x$ di 4 bit $x_3 x_2 x_1 x_0$:

```c
if (x è pari)  { if (x è divisibile per 4) z = 1; else z = 0; }
else           z = 1;
```

*Con l'approccio strutturale* servono due condizioni:

- $x$ pari: $x_0 = 0$, cioè $overline(x_0)$;
- $x$ divisibile per 4: dividere per $4 = 2^2$ vuol dire spostare i bit di due posti a destra (_shift_). I due bit che escono, $x_1 x_0$, sono il resto $x mod 4$: deve essere 00. "Tutti e due 0" è un OR negato (NOR): l'OR vale 0 solo se entrambi sono 0. Per De Morgan è lo stesso che $overline(x_1) dot overline(x_0)$.

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  figura(canvas(length: 0.8cm, {
    import draw: *
    trap((0, 0))
    content((0.5, 1), [1]); fr((0.5, 0.75), (0.5, 0))
    porta-nor((2.6, 1.3), h: 1)
    for (y, t) in ((1.6, $x_1$), (1, $x_0$)) { line((2, y), (2.7, y)); content((1.7, y), t) }
    line((3.86, 1.3), (4.1, 1.3), (4.1, 0.45), (1.5, 0.45)); fr((1.5, 0.45), (1.5, 0))
    content((-1.6, -0.35), $x_0$); line((-1.3, -0.35), (-0.01, -0.35)); circle((0.07, -0.35), radius: 0.08)
    content((-0.6, -0.05), text(8pt)[pari])
    fr((1, -0.7), (1, -1.3)); content((1, -1.6), $z$)
  }), [Due `if` → due MUX; il secondo si riduce a una NOR]),
  [
    Ogni `if` è un MUX. Quello interno sceglie 1 se la NOR vale 1 e 0 se vale 0: la sua uscita è la NOR stessa, quindi il MUX si butta e resta la NOR. Quello esterno è comandato da $overline(x_0)$: dispari → 1, pari → la NOR.

    Altra semplificazione: nel ramo "pari" si sa già che $x_0 = 0$, quindi basta controllare $x_1 = 0$.
  ],
))

*Con tabella e mappa*: $z = 1$ se $x_0 = 1$ (dispari) oppure se $x_1 x_0 = 00$. Ogni condizione riassume 8 righe della tabella:

#block(breakable: false, grid(columns: (auto, auto, 1fr), gutter: 2em, align: horizon,
  table(columns: 5, align: center, inset: 5pt,
    stroke: (x, y) => if x == 3 { (right: 1pt) } + if y == 0 { (bottom: 1pt) },
    $x_3$, $x_2$, $x_1$, $x_0$, $z$,
    [−], [−], [−], [1], [1],
    [−], [−], [0], [0], [1],
  ),
  kmap(($x_1$, $x_0$), ($x_3$, $x_2$), (c, r) => if c == (1, 0) { 0 } else { 1 },
    gruppi: ((0, 0, 2, 4, red), (1.06, 0.06, 1.88, 3.88, blu))),
  [Dalla tabella: $z = x_0 + overline(x_1) thin overline(x_0)$. \
   Sulla mappa due gruppi da 8, che *possono sovrapporsi*: basta che coprano tutti gli 1, i più grandi possibile. \
   $z = #text(fill: red)[$overline(x_1)$] + #text(fill: blu)[$x_0$]$: più semplice.],
))

#video("12", "19:31", "32:14")Il secondo esempio è un *moltiplicatore* di due numeri senza segno da 2 bit: $x_1 x_0 dot y_1 y_0 = z_3 z_2 z_1 z_0$. L'uscita ha 4 bit, perché moltiplicando i bit raddoppiano: $3 dot 3 = 9 = 1001$.

#let molt(b) = (b.at(0) * 2 + b.at(1)) * (b.at(2) * 2 + b.at(3))
#let zk(k) = b => calc.rem(calc.quo(molt(b), calc.pow(2, k)), 2)
#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  tvb(($x_1$, $x_0$, $y_1$, $y_0$), ($z_3$, zk(3)), ($z_2$, zk(2)), ($z_1$, zk(1)), ($z_0$, zk(0))),
  [
    Se $x = 0$ il prodotto è 0; se $x = 1$ si ricopia $y$; e così via. Si cercano poi gli 1 in righe che differiscono per *un solo bit*: quel bit si raccoglie e sparisce, come su una mappa.

    $ z_3 &= x_1 x_0 y_1 y_0 \
      z_2 &= x_1 overline(x_0) y_1 + x_1 y_1 overline(y_0) \
      z_1 &= overline(x_1) x_0 y_1 + x_1 overline(x_0) y_0 + x_1 x_0 overline(y_1) y_0 + x_1 x_0 y_1 overline(y_0) \
      z_0 &= overline(x_1) x_0 y_0 + x_1 x_0 y_0 = x_0 y_0 $

    Per $z_2$: le righe 1010 e 1011 differiscono solo per $y_0$, e danno $x_1 overline(x_0) y_1$; 1010 e 1110 solo per $x_0$, e danno $x_1 y_1 overline(y_0)$.
  ],
))

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  kmap(($x_1$, $x_0$), ($y_1$, $y_0$), (c, r) => c.at(1) * r.at(1), gruppi: ((1, 1, 2, 2, blu),)),
  [Per $z_0$ i due termini stanno lontani nella tabella (righe 0101-0111 e 1101-1111), e si vede che si raccolgono solo facendo il conto. Sulla mappa i quattro 1 sono un quadrato: $z_0 = x_0 y_0$ subito. È a questo che servono le mappe.],
))

#video("15", "00:33", "14:33")Si può anche fare il contrario: partire da una rete già disegnata, scriverne la formula e chiedersi se si può calcolare la stessa cosa in modo più efficiente. Questa rete ha un AND per ogni termine (il pallino nega l'ingresso) e una OR che li raccoglie:

#block(breakable: false, grid(columns: (auto, auto), gutter: 3em, align: horizon,
  figura(rete-sp(($a$, $b$, $c$), ((0, 1, 1), (1, 1, 0), (1, 1, 1))), [La rete da leggere]),
  figura(kmap(($b$, $c$), ($a$,), (c, r) => calc.max(c.at(0) * c.at(1), r.at(0) * c.at(0)),
    gruppi: ((2, 0, 1, 2, blu), (2.06, 1.06, 1.88, 0.88, red))),
    [#text(fill: blu)[$b c$]: la colonna 11, $a$ cambia \ #text(fill: red)[$a b$]: la riga $a = 1$, $c$ cambia]),
))

Il terzo termine differisce dal primo solo per $a$ e dal secondo solo per $c$: lo si usa due volte.

$ z = overline(a) b c + a b overline(c) + a b c = underbrace(overline(a) b c + a b c, b c) + underbrace(a b overline(c) + a b c, a b) = b c + a b = b (c + a) $

La mappa dà subito $b c + a b$: 2 AND e una OR. Il raccoglimento $b (c + a)$ invece sulla mappa non si vede: lì si cercano solo i gruppi più grandi. Raccogliendo resta una OR e un AND, una porta in meno. I livelli sono sempre due, quindi $2 Delta t$. La rete di partenza ha due livelli solo con porte da 8 ingressi: con porte da 2, l'AND da tre e l'OR da tre diventano due livelli ciascuno, e i livelli sono 4.

#video("15", "14:41", "29:37")Le mappe convengono soprattutto quando gli 1 sono tanti. Ne è un esempio il *display a sette segmenti* di calcolatrici e orologi: ogni cifra si forma accendendo alcuni dei sette segmenti, che per convenzione si chiamano $a$…$g$ ($a$ in alto, poi in senso orario, $g$ al centro; il punto decimale qui non serve). La rete riceve una cifra da 0 a 9 in binario, $x_3 x_2 x_1 x_0$, e dà 1 sui segmenti da accendere e 0 su quelli da lasciare spenti.

#let seg = ("1111110", "0110000", "1101101", "1111001", "0110011", "1011011", "1011111", "1110000", "1111111", "1111011")
#let display(acceso, nomi: false) = canvas(length: 0.65cm, {
  import draw: *
  let pezzi = (((0.25, 2), (1.15, 2)), ((1.3, 1.85), (1.3, 1.15)), ((1.3, 0.85), (1.3, 0.15)), ((0.25, 0), (1.15, 0)),
    ((0.1, 0.15), (0.1, 0.85)), ((0.1, 1.15), (0.1, 1.85)), ((0.25, 1), (1.15, 1)))
  for (k, (p, q)) in pezzi.enumerate() {
    line(p, q, stroke: (paint: if acceso.at(k) == "1" { red } else { luma(225) }, thickness: 4pt, cap: "round"))
  }
  if nomi {
    for (t, p) in ($a$, $b$, $c$, $d$, $e$, $f$, $g$).zip(((0.7, 2.45), (1.75, 1.5), (1.75, 0.5), (0.7, -0.45), (-0.35, 0.5), (-0.35, 1.5), (0.7, 1.4))) {
      content(p, text(8pt, t))
    }
  }
})
#block(breakable: false, grid(columns: (auto, auto, 1fr), gutter: 2em, align: horizon,
  figura(display("1111111", nomi: true), [I nomi dei segmenti]),
  figura(display(seg.at(4)), [Il 4 = 0100: \ $f, b, g, c$ accesi]),
  table(columns: 12, align: center, inset: 3.5pt,
    stroke: (x, y) => if x == 0 or x == 4 { (right: 1pt) } + if y == 0 { (bottom: 1pt) },
    [cifra], $x_3$, $x_2$, $x_1$, $x_0$, ..($a$, $b$, $c$, $d$, $e$, $f$, $g$),
    ..range(10).map(n => ([#n], ..range(4).map(i => [#calc.rem(calc.quo(n, calc.pow(2, 3 - i)), 2)]),
      ..seg.at(n).clusters().map(v => if v == "1" { text(fill: blu, weight: "bold")[1] } else [0]))).flatten()),
))

Sette colonne d'uscita sono sette reti combinatorie, ognuna con 4 ingressi, e quindi sette mappe. Per $g$ la somma di prodotti avrebbe 7 termini da 4 variabili ($overline(x_3) thin overline(x_2) x_1 overline(x_0) + dots$). Sulla mappa conviene mettere prima i tre 0 (cifre 0, 1 e 7) e riempire il resto. Le combinazioni da 1010 a 1111 (da 10 a 15) non sono cifre e non capitano mai: sono − come nel codificatore, e si contano come 1 dove serve.

#let arancio = rgb("#e08a00")
#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  kmap(x10, x32, (c, r) => {
    let n = r.at(0) * 8 + r.at(1) * 4 + c.at(0) * 2 + c.at(1)
    if n > 9 [−] else { int(seg.at(n).at(6)) }
  }, gruppi: ((0, 2, 4, 2, blu), (3.06, 0.06, 0.88, 3.88, verde), (0.12, 1.12, 1.76, 1.76, red),
    (2.12, -0.35, 1.76, 1.3, arancio), (2.12, 3.05, 1.76, 1.3, arancio))),
  [
    - #text(fill: blu)[blu], 8 celle: le righe 11 e 10, conta solo $x_3 = 1$. Termine $x_3$.
    - #text(fill: verde)[verde], 4 celle: la colonna 10. Termine $x_1 overline(x_0)$.
    - #text(fill: red)[rosso], 4 celle: righe 01 e 11, colonne 00 e 01. Termine $overline(x_1) x_2$.
    - #text(fill: arancio)[arancio], 4 celle: righe 00 e 10 (la mappa si richiude sopra e sotto), colonne 11 e 10. Termine $x_1 overline(x_2)$.

    $ g = x_3 + x_1 overline(x_0) + overline(x_1) x_2 + x_1 overline(x_2) $
  ],
))

I gruppi si sovrappongono, ma va bene: un 1 coperto due volte non costa niente, mentre un gruppo da 4 toglie due variabili e uno da 2 una sola. Coprire gli stessi 1 con gruppi da 2 e da 1 darebbe termini più lunghi.

== Descrivere le reti in Verilog

#video("11", "00:49", "08:35")Una rete progettata sulla carta si può provare al calcolatore prima di costruirla, perché stamparla sul silicio è lungo e costoso. Si usa un *HDL* (_Hardware Description Language_): un linguaggio di programmazione che invece di un algoritmo descrive come funziona un circuito. I più usati sono VHDL e *Verilog*; nel corso si usa Verilog (versione 2003, non il SystemVerilog del libro), perché ha strumenti gratuiti per ogni sistema operativo:

#align(center, text(9pt, stack(dir: ltr, spacing: 0.5em,
  box(stroke: 0.6pt, inset: 7pt)[`mux.v` \ il circuito], align(horizon)[+],
  box(stroke: 0.6pt, inset: 7pt)[`test.v` \ la prova], align(horizon)[→],
  box(stroke: 0.6pt, inset: 7pt, fill: azzurro)[*iverilog* \ compila], align(horizon)[→],
  box(stroke: 0.6pt, inset: 7pt, fill: azzurro)[*vvp* \ simula], align(horizon)[→],
  box(stroke: 0.6pt, inset: 7pt)[`test.vcd` \ i risultati], align(horizon)[→],
  box(stroke: 0.6pt, inset: 7pt, fill: rgb("#fff3c4"))[*gtkwave* \ forme d'onda],
)))

```sh
$ iverilog mux.v test.v      # compila: crea a.out
$ vvp a.out                  # simula: scrive test.vcd (basta anche ./a.out)
$ gtkwave test.vcd           # mostra i segnali nel tempo
```

Ogni pezzo di circuito è un *modulo*, che si scrive come una funzione: i parametri sono i fili d'ingresso (`input`) e d'uscita (`output`), di solito prima le uscite. Un nome solo vuol dire un filo da 1 bit. Il MUX si può scrivere in tre modi.

#video("11", "09:14", "13:52")*1. Come tabella di verità*, con una `primitive`. Ogni riga dà i valori degli ingressi nell'ordine dei parametri, poi `:` e l'uscita; `?` è il valore che non conta (il − delle tabelle).

```verilog
primitive mux(output z, input x, input y, input c);
  table
  // x y c : z
     0 ? 0 : 0;
     1 ? 0 : 1;
     ? 0 1 : 0;
     ? 1 1 : 1;
  endtable
endprimitive
```

#nota[Una `primitive` ha *una sola uscita* da 1 bit, e la tabella deve coprire *tutte* le combinazioni, anche quelle con uscita 0. Se mancano, lì l'uscita non vale 0 ma `x` (non definito).]

#video("11", "14:44", "23:31")Prima di vedere gli altri due modi, questo MUX si può già provare. Si scrive un *modulo di test*, senza parametri: è il "main". Dentro si crea una *copia* (istanza) del circuito: non è una chiamata di funzione ma un pezzo di hardware, e se ne possono creare quante se ne vuole, ognuna col suo nome.

```verilog
module test;
  reg x, y, c;                 // ingressi: il test ci scrive i valori
  wire z;                      // uscita: si può solo leggere
  mux m(z, x, y, c);           // una copia del MUX, di nome m
  integer i;
  initial begin                // eseguito all'accensione
    $dumpfile("test.vcd");     // dove salvare i risultati
    $dumpvars;                 // salva ogni cambiamento dei segnali
    for (i = 0; i < 8; i++) begin
      {x, y, c} = i;           // i in binario: x è il bit più a sinistra
      #2;                      // aspetta 2 unità di tempo
    end
    $finish;                   // fine, altrimenti la simulazione non termina
  end
endmodule
```

Le graffe `{x, y, c}` *mettono insieme* tre fili in un numero da 3 bit: il `for` da 0 a 7 prova così tutte le combinazioni degli ingressi. Con `$monitor(...)` il test stampa anche i valori a ogni cambiamento, e con un `if` può controllare da solo se l'uscita è quella giusta.

#figura(onde(w: 0.65, range(3).map(k => ((($x$, $y$, $c$).at(k)), range(8).map(i => calc.rem(calc.quo(i, calc.pow(2, 2 - k)), 2))))
  + (($z$, range(8).map(i => if calc.rem(i, 2) == 0 { calc.quo(i, 4) } else { calc.rem(calc.quo(i, 2), 2) })),)),
  [Quello che mostra gtkwave per il test: i da 0 a 7. Con $c = 0$ l'uscita copia $x$, con $c = 1$ copia $y$])

#video("11", "25:03", "30:05")Gli altri due modi di scrivere il MUX hanno gli stessi parametri, quindi il test di prima li prova senza cambiare niente.

*2. Come formula*, con un `module` e `assign`: ogni volta che cambia un ingresso, ricalcola l'uscita. Un'uscita = un `assign`. L'AND lega più dell'OR, come il prodotto sulla somma, quindi qui le parentesi non servono.

```verilog
module mux(output z, input x, input y, input c);
  assign z = !c && x || c && y;
endmodule
```

#align(center, table(columns: 4, align: center,
  [], [AND], [OR], [NOT],
  [in Verilog], [`&&` oppure `&`], [`||` oppure `|`], [`!` oppure `~`],
))

Si possono usare anche le *porte già pronte* `and`, `or`, `not`: il primo parametro è l'uscita. I collegamenti interni sono fili, dichiarati con `wire`.

```verilog
module mux(output z, input x, input y, input c);
  wire nc, a1, a2;
  not(nc, c);
  and(a1, nc, x);
  and(a2, c, y);
  or(z, a1, a2);
endmodule
```

*3. Come in C*, con l'espressione `cond ? a : b`: vale `a` se `cond` è vera, altrimenti `b`. Qui gli ingressi hanno *N bit*: `[N-1:0]` vuol dire i bit da $N-1$ a 0, e il parametro N ha un valore che si può cambiare per ogni copia del modulo. Nel test, per esempio, `mux #(1) m(z, x, y, c);` crea una copia con N = 1.

```verilog
module mux #(parameter N = 32)
           (output [N-1:0] z, input [N-1:0] x, input [N-1:0] y, input c);
  assign z = (c == 0 ? x : y);
endmodule
```

#nota[Il prof scrive `parameter N = 32;` dentro il modulo, dopo la testa. Con Icarus 13 così non compila (_Unable to bind parameter_): N è usato nella testa prima di essere dichiarato. Va messo nella testa, con `#(parameter N = 32)` subito dopo il nome.]

Le costanti si scrivono con bit, base e valore: `1'b0` è 0 su 1 bit in binario, `16'd5` è 5 su 16 bit scritto in decimale.

#video("11", "38:19", "48:45")Dopo la simulazione ci sono altri due passi. Il primo è provare il circuito su una *FPGA*: un chip con una griglia di milioni di celle, dove ogni cella si può configurare come una piccola funzione (4-5 bit d'ingresso, 1 d'uscita), come registro da 1 bit, o come incrocio che instrada i segnali fra le celle vicine. Il Verilog compilato dice come configurare le celle; la configurazione si scrive sul chip come su una chiavetta, e resta anche a corrente spenta. Collegando interruttori ai piedini si prova il circuito vero. L'FPGA si può riprogrammare: oggi un MUX, domani un full adder.

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  figura(canvas(length: 0.45cm, {
    import draw: *
    for i in range(7) { for j in range(5) {
      let usata = (i, j) in ((1, 1), (2, 1), (2, 2), (4, 3))
      rect((i, -j), (i + 0.7, -j - 0.7), fill: if usata { rgb("#fff3c4") } else { azzurro }, stroke: 0.4pt)
    } }
    line((1.7, -1.35), (2, -1.35), stroke: 1pt + red); line((2.35, -1.7), (2.35, -2), stroke: 1pt + red)
    line((2.7, -2.35), (4.35, -2.35), (4.35, -3), stroke: 1pt + red)
  }), [FPGA: in giallo le celle usate, \ in rosso i segnali fra loro]),
  figura(align(left, text(9pt, stack(dir: ltr, spacing: 0.4em,
    box(stroke: 0.6pt, inset: 6pt)[Verilog], align(horizon)[→],
    box(stroke: 0.6pt, inset: 6pt, fill: azzurro)[simulazione \ (iverilog)], align(horizon)[→],
    box(stroke: 0.6pt, inset: 6pt, fill: azzurro)[prova \ su FPGA], align(horizon)[→],
    box(stroke: 0.6pt, inset: 6pt, fill: rgb("#fff3c4"))[_silicon compiler_ \ → maschere → fonderia],
  ))), [Il percorso dal Verilog al chip]),
))

Quando tutto funziona, un *silicon compiler* prende lo stesso Verilog e produce tutto quello che serve per stampare il chip: le *maschere* da mandare alla fonderia.

#video("11", "48:50", "52:39")I moduli si *compongono*: un modulo può contenere copie di altri moduli. Il full adder ha due uscite, quindi non sta in una `primitive`: si scrivono due tabelle, una per il risultato e una per il riporto, e un modulo che le usa tutte e due sugli stessi ingressi.

```verilog
primitive far(output z, input x, input y, input r);   // risultato
  table  0 0 0 : 0;  0 0 1 : 1;  0 1 0 : 1;  0 1 1 : 0;
         1 0 0 : 1;  1 0 1 : 0;  1 1 0 : 0;  1 1 1 : 1;  endtable
endprimitive

primitive fac(output c, input x, input y, input r);   // riporto
  table  0 0 0 : 0;  0 0 1 : 0;  0 1 0 : 0;  0 1 1 : 1;
         1 0 0 : 0;  1 0 1 : 1;  1 1 0 : 1;  1 1 1 : 1;  endtable
endprimitive

module fa(output c, output z, input x, input y, input r);
  far ris(z, x, y, r);
  fac car(c, x, y, r);
endmodule
```

Allo stesso modo due `fa`, col riporto del primo portato al secondo da un `wire`, fanno il sommatore a 2 bit; e così via fino a un processore intero, un pezzo alla volta, provando ogni pezzo da solo.

#video("15", "29:40", "36:23")Resta da vedere come funziona una cella dell'FPGA. Ogni cella calcola la sua funzione senza porte su misura: tiene la colonna d'uscita della tabella di verità in un registro, e gli ingressi, come controllo di un MUX, scelgono quale bit esce. È un'idea che vale anche fuori dalle FPGA. Per il display a sette segmenti, invece di sette formule, si mettono le dieci righe d'uscita della tabella in dieci registri da 7 bit, collegati agli ingressi di un MUX comandato dalla cifra $x_3 x_2 x_1 x_0$: 4 bit di controllo, quindi 16 ingressi. La cifra 4 = 0100 fa passare il registro con 0110011, e i 7 fili d'uscita vanno ai segmenti. Il ritardo è la lettura del registro più quello del MUX. Gli ingressi da 1010 a 1111 vanno comunque riempiti, per esempio con tutto spento.

#figura(canvas(length: 0.8cm, {
  import draw: *
  let regs = ((1.1, "0", "1111110"), (2.9, "1", "0110000"), (4.7, "2", "1101101"), (8.7, "9", "1111011"))
  line((0, 0), (10, 0), (9.6, -0.7), (0.4, -0.7), close: true, fill: azzurro)
  for (x, n, v) in regs {
    content((x, 1.75), text(8pt)[#n])
    rect((x - 0.75, 1.5), (x + 0.75, 1.05), fill: rgb("#fff3c4")); content((x, 1.27), text(7pt, mono(v)))
    fr((x, 1.05), (x, 0)); bus((x, 0.5), [7])
    content((x, -0.22), text(7pt, mono(c2(int(n), 4))))
  }
  content((6.7, 1.27), [⋯]); content((6.7, -0.22), text(7pt)[⋯])
  content((-1.6, -0.35), $x_3 x_2 x_1 x_0$); fr((-0.6, -0.35), (0.25, -0.35)); bus((-0.2, -0.35), [4])
  fr((5, -0.7), (5, -1.5)); bus((5, -1.1), [7]); content((5, -1.8), text(9pt)[ai segmenti $a, b, c, d, e, f, g$])
}), [La tabella del display in registri: la cifra sceglie quale riga esce])

#video("15", "38:56", "52:09")La simulazione mostra anche cose che sulla carta sfuggono. Finora il NOT costava 0, ma in realtà un po' di tempo lo prende. Supponiamo allora che *ogni* porta, NOT compreso, risponda dopo un'unità di tempo. In Verilog si scrive `#1` dopo `assign`: ogni volta che cambia un ingresso, l'uscita si aggiorna un'unità di tempo dopo. Con queste porte "lente" si ricostruisce il MUX:

```verilog
module and_d(output z, input x, input y);
  assign #1 z = x && y;            // or_d e not_d uguali, con || e !
endmodule

module mux_d(output z, input x, input y, input c);
  wire w1, w2, w3;
  not_d n(w1, c);                  // w1 = not c
  and_d a1(w2, x, w1);             // w2 = not c and x
  and_d a2(w3, y, c);              // w3 = c and y
  or_d  o(z, w2, w3);
endmodule
```

#let al-n = 12
#let prima(v, i) = v.at(calc.max(i - 1, 0))
#let al-c = range(al-n).map(i => if i < 3 or i >= 8 { 1 } else { 0 })
#let al-w1 = range(al-n).map(i => 1 - prima(al-c, i))
#let al-w2 = range(al-n).map(i => prima(al-w1, i))   // x = 1
#let al-w3 = range(al-n).map(i => prima(al-c, i))    // y = 1
#let al-z = range(al-n).map(i => calc.max(prima(al-w2, i), prima(al-w3, i)))
#let al-z2 = range(al-n).map(i => calc.max(prima(al-w2, i), prima(al-w3, i), 1))   // in più x and y = 1
Il test tiene $x = y = 1$ e cambia solo $c$: l'uscita dovrebbe restare 1, qualunque ingresso si scelga. Ecco invece cosa mostra gtkwave (ogni colonna è un'unità di tempo):

#figura(onde(w: 0.55, righe: (3, 8), (($c$, al-c), ($overline(c)$, al-w1), ($overline(c) x$, al-w2), ($c y$, al-w3), ($z$, al-z), ([$z$ con $x y$], al-z2))),
  [Quando $c$ scende, $c y$ va a 0 dopo un'unità, $overline(c) x$ sale solo dopo due (NOT e poi AND): \ per un'unità l'OR vede due 0, e $z$ ha un buco. Quando $c$ risale non succede])

Questo disturbo si chiama *alea*: per un attimo l'uscita vale il contrario di quello che dovrebbe. Sulla mappa si vede da dove viene. Con $x = y = 1$ il passaggio è fra due 1 vicini che stanno in due gruppi diversi, $overline(c) x$ e $c y$: per un attimo nessuno dei due termini vale 1. Ogni salto di questo tipo può dare un'alea, ma non è detto che succeda.

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  kmap(($x$, $y$), ($c$,), (c, r) => if r.at(0) == 0 { c.at(0) } else { c.at(1) },
    gruppi: ((2.06, 0.06, 1.88, 0.88, red), (1.06, 1.06, 1.88, 0.88, red), (2, 0, 1, 2, blu))),
  [Si toglie aggiungendo un gruppo che copre i due 1 del passaggio, #text(fill: blu)[la colonna $x y = 11$]:
   $ z = overline(c) x + c y + #text(fill: blu)[$x y$] $
   Il termine $x y$ non copre nessun 1 nuovo, ma con $x = y = 1$ tiene l'uscita a 1 qualunque cosa faccia $c$: nell'ultima riga delle forme d'onda il buco non c'è più.],
))

Il prezzo è un AND in più e un ingresso in più nell'OR: con porte da 8 i livelli restano due, con porte da 2 l'OR da tre diventa un albero e il ritardo cresce.

== Memoria: latch, flip-flop, registro

#video("13", "06:16", "11:11")Finora le reti calcolavano funzioni: stesso ingresso, stessa uscita. Una rete *sequenziale* invece *ricorda*: l'uscita dipende dalla sequenza di ingressi ricevuti. Il mattone è un circuito a cui si può dire "ricordati 1" o "ricordati 0", con due uscite: $Q$, il valore ricordato, e $overline(Q)$, il suo negato. L'obiettivo è il *registro*:

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  canvas(length: 0.8cm, {
    import draw: *
    rect((0, 0), (2.4, -1.2), fill: azzurro); content((1.2, -0.6), [registro])
    content((1.2, 1.1), $x$); fr((1.2, 0.85), (1.2, 0)); bus((1.2, 0.45), $n$)
    fr((1.2, -1.2), (1.2, -2)); content((1.2, -2.3), $z$); bus((1.2, -1.6), $n$)
    fr((-1.2, -0.3), (0, -0.3), stroke: (dash: "dashed")); content((-1.4, -0.3), anchor: "east", text(9pt)[clock])
    fr((-1.2, -0.9), (0, -0.9)); content((-1.4, -0.9), anchor: "east", text(9pt)[WE])
  }),
  [Se *clock = 1 e WE = 1* (_write enable_, "scrittura abilitata"), il registro si ricorda l'ingresso $x$ di $n$ bit: da lì in poi $z$ vale $x$. Altrimenti continua a ricordare il valore di prima, come un foglio dove resta scritto l'ultimo numero finché non lo si cancella. Il clock è il segnale che sale e scende a ritmo fisso, visto all'inizio; nei disegni il suo filo è tratteggiato.],
))

Ci si arriva in quattro passi, dal più semplice, facendo prima il circuito per *un bit*.

#video("13", "12:25", "27:21")Il primo è il *latch SR* (_Set Reset_): due porte NOR (OR seguito da NOT) con le uscite *incrociate*, cioè l'uscita di ognuna torna indietro come ingresso dell'altra. $S = 1$ vuol dire "ricordati 1", $R = 1$ "ricordati 0".

#let sr-s = (0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1)
#let sr-r = (0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1)
#let sr-q = sim(12, (i, p) => if sr-s.at(i) == 1 { 1 - sr-r.at(i) } else if sr-r.at(i) == 1 { 0 } else { p })
#let sr-nq = range(12).map(i => if sr-s.at(i) + sr-r.at(i) == 2 { 0 } else if sr-q.at(i) == none { none } else { 1 - sr-q.at(i) })
#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  figura(canvas(length: 0.8cm, {
    import draw: *
    porta-nor((1.5, 1.6)); porta-nor((1.5, -0.4))
    content((0.2, 1.8), $R$); line((0.45, 1.8), (1.6, 1.8))
    content((0.2, -0.6), $S$); line((0.45, -0.6), (1.6, -0.6))
    line((2.65, 1.6), (4, 1.6)); content((4.3, 1.6), $Q$)
    line((2.65, -0.4), (4, -0.4)); content((4.3, -0.4), $overline(Q)$)
    circle((3.3, 1.6), radius: 0.05, fill: black); circle((3, -0.4), radius: 0.05, fill: black)
    line((3.3, 1.6), (3.3, 1), (1, 0.3), (1, -0.2), (1.6, -0.2))
    line((3, -0.4), (3, 0.2), (1.2, 0.9), (1.2, 1.4), (1.6, 1.4))
  }), [Latch SR]),
  table(columns: 4, align: center,
    [$S$], [$R$], [$Q$], [],
    [0], [0], [quello di prima], [ricorda],
    [1], [0], [1], [_set_],
    [0], [1], [0], [_reset_],
    [1], [1], text(fill: red)[$Q = overline(Q) = 0$], text(fill: red)[vietato],
  ),
))

Per capire perché funziona si segue il segnale. Con $R = 1$, $S = 0$: la NOR in alto ha un ingresso a 1, quindi dà $Q = 0$. Quello 0 torna nella NOR in basso, che ora ha tutti e due gli ingressi a 0 e dà $overline(Q) = 1$. A sua volta l'1 torna in alto, dove non cambia niente: il circuito si è *stabilizzato*. Se ora anche $R$ torna a 0, gli ingressi che rientrano dall'altra porta sono ancora quelli di prima, e $Q = 0$ resta. Con $S = 1$ succede lo stesso al contrario, perché il circuito è simmetrico. Il valore resta finché c'è corrente.

#figura(onde(righe: (2, 6, 10), (($S$, sr-s), ($R$, sr-r), ($Q$, sr-q), ($overline(Q)$, sr-nq))),
  [All'inizio $Q$ non è definito (grigio). Set, poi tutto a 0: ricorda 1. Reset: ricorda 0. Alla fine $S = R = 1$: $Q$ e $overline(Q)$ valgono tutti e due 0])

#video("13", "29:05", "40:55")Il problema è proprio $S = R = 1$: entrambe le NOR danno 0, e $Q$ e $overline(Q)$ non sono più uno il negato dell'altro. Si risolve col secondo passo, il *latch D*: davanti al latch SR si mettono due AND, e due ingressi nuovi, il *clock*, che dice *quando* scrivere (quando vale 1), e $D$, che dice *cosa* scrivere. A $S$ arriva clock AND $D$, a $R$ arriva clock AND $overline(D)$: $S$ e $R$ non possono più valere 1 insieme.

#let dl-n = 16
#let dl-c = clock(dl-n)
#let dl-d = (0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 0)
#let dl-q = sim(dl-n, (i, p) => if dl-c.at(i) == 1 { dl-d.at(i) } else { p })
#let ff-q = sim(dl-n, (i, p) => if i > 0 and dl-c.at(i) == 1 and dl-c.at(i - 1) == 0 { dl-d.at(i) } else { p })
#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  figura(canvas(length: 0.8cm, {
    import draw: *
    rect((3, -0.3), (4.4, 2.1), fill: azzurro); content((3.7, 0.9), text(9pt)[latch \ SR])
    content((3.25, 1.8), text(8pt)[R]); content((3.25, 0), text(8pt)[S])
    porta-and((1.6, 1.8), h: 0.8); porta-and((1.6, 0), h: 0.8)
    line((2.4, 1.8), (3, 1.8)); line((2.4, 0), (3, 0))
    line((1.1, 2.6), (1.1, 0.2), (1.6, 0.2), stroke: (dash: "dashed")); line((1.1, 2), (1.6, 2), stroke: (dash: "dashed"))
    content((1.1, 2.85), text(8pt)[clock])
    content((-0.6, -0.2), $D$); line((-0.3, -0.2), (1.6, -0.2))
    circle((0.4, -0.2), radius: 0.05, fill: black); line((0.4, -0.2), (0.4, 1.6), (1.44, 1.6)); circle((1.52, 1.6), radius: 0.08)
    fr((4.4, 1.8), (5.1, 1.8)); content((5.4, 1.8), $Q$)
    fr((4.4, 0), (5.1, 0)); content((5.4, 0), $overline(Q)$)
  }), [Latch D (il clock si disegna tratteggiato)]),
  figura(onde(righe: fronti(dl-n), (([clock], dl-c), ($D$, dl-d),
    ($S$, range(dl-n).map(i => dl-c.at(i) * dl-d.at(i))), ($R$, range(dl-n).map(i => dl-c.at(i) * (1 - dl-d.at(i)))), ($Q$, dl-q))),
    [Col clock alto: $D = 0$ fa un reset, $D = 1$ un set. Col clock basso $Q$ non cambia]),
))

Ma anche qui c'è un problema: *mentre il clock è 1* il latch copia $D$ in continuazione (si dice che è *trasparente*). Se $D$ cambia mentre il clock è alto, nello stesso ciclo arrivano un set e un reset, e $Q$ cambia due volte (terzo ciclo: prima un reset, poi un set). Invece in un ciclo di clock si deve scrivere un solo valore. Quindi *$D$ non può cambiare mentre il clock vale 1*.

#video("13", "40:56", "49:06")Il terzo passo toglie anche questo vincolo: il *flip-flop*, fatto di due latch D in fila. Il $Q$ del primo, il *master*, è il $D$ del secondo, lo *slave*. Lo slave riceve il clock, il master il clock *negato*: quando scrive uno, l'altro è *opaco* (non fa passare niente).

#block(breakable: false, grid(columns: (auto, auto), gutter: 2.5em, align: horizon,
  figura(canvas(length: 0.8cm, {
    import draw: *
    for (x, t) in ((0, [master]), (3, [slave])) {
      rect((x, 0), (x + 1.6, -1.2), fill: azzurro); content((x + 0.8, -0.6), text(9pt)[latch D])
      content((x + 0.8, -1.5), text(8pt, t))
      line((x + 0.65, 0), (x + 0.8, -0.2), (x + 0.95, 0))
    }
    content((-1, -0.6), $D$); fr((-0.7, -0.6), (0, -0.6))
    fr((1.6, -0.6), (3, -0.6)); content((2.3, -0.35), text(8pt)[$Q$ → $D$])
    fr((4.6, -0.6), (5.3, -0.6)); content((5.6, -0.6), $Q$)
    line((3.8, 1.2), (3.8, 0), stroke: (dash: "dashed")); line((0.8, 0.8), (0.8, 0.16), stroke: (dash: "dashed"))
    circle((0.8, 0.08), radius: 0.08); circle((3.8, 0.8), radius: 0.05, fill: black)
    line((3.8, 0.8), (0.8, 0.8), stroke: (dash: "dashed")); content((3.8, 1.45), text(8pt)[clock])
  }), [Flip-flop master-slave: il pallino nega il clock del master]),
  figura(canvas(length: 0.8cm, {
    import draw: *
    rect((0, 0), (1.2, -1.2), fill: azzurro)
    line((0.45, 0), (0.6, -0.2), (0.75, 0)); line((0.6, 0.7), (0.6, 0), stroke: (dash: "dashed"))
    content((-0.7, -0.6), $D$); fr((-0.45, -0.6), (0, -0.6)); fr((1.2, -0.6), (1.8, -0.6)); content((2.1, -0.6), $Q$)
  }), [Simbolo: il triangolo \ è l'ingresso del clock]),
))

Col clock basso scrive il master, e lo slave tiene fermo $Q$. Quando il clock *sale* il master diventa opaco e lo slave copia quello che il master aveva scritto. Non c'è mai un momento in cui scrivono tutti e due, quindi il cammino da $D$ a $Q$ è sempre interrotto da qualche parte: $Q$ cambia *solo sul fronte di salita* del clock, e i cambiamenti di $D$ negli altri momenti non contano.

#figura(onde(righe: fronti(dl-n), (([clock], dl-c), ($D$, dl-d), ([$Q$ latch D], dl-q), ([$Q$ flip-flop], ff-q))),
  [Stessi ingressi: il latch D segue $D$ per tutto il tempo in cui il clock è alto, il flip-flop prende $D$ solo sul fronte di salita (linee tratteggiate)])

#video("13", "49:11", "51:06")L'ultimo passo è il *write enable*: invece di dare il clock direttamente al flip-flop, gli si dà clock AND WE. Con WE = 0 l'AND dà sempre 0, il flip-flop non vede mai salire il clock e tiene il suo valore. Un *registro da $n$ bit* è una fila di $n$ flip-flop, ognuno col suo bit, con lo stesso clock e lo stesso WE.

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  figura(canvas(length: 0.8cm, {
    import draw: *
    porta-and((-0.6, 1.4), h: 0.8)
    line((-1.3, 1.6), (-0.6, 1.6), stroke: (dash: "dashed")); content((-1.9, 1.6), text(8pt)[clock])
    line((-1.3, 1.2), (-0.6, 1.2)); content((-1.7, 1.2), text(8pt)[WE])
    line((0.2, 1.4), (0.5, 1.4), (0.5, -1.85))
    for (k, y) in ((0, 0), (1, -1.6)) {
      rect((1.2, y + 0.5), (2.4, y - 0.5), fill: azzurro)
      line((1.2, y - 0.1), (1.4, y - 0.25), (1.2, y - 0.4))
      circle((0.5, y - 0.25), radius: 0.05, fill: black); line((0.5, y - 0.25), (1.2, y - 0.25))
      content((-1, y + 0.2), $x_#k$); fr((-0.7, y + 0.2), (1.2, y + 0.2))
      fr((2.4, y), (3.1, y)); content((3.4, y), $z_#k$)
    }
  }), [Registro da 2 bit]),
  [Ogni bit costa sempre più porte: il latch SR 2, il latch D 4 (il NOT non si conta), il flip-flop 8, con il WE 9.

   Il registro si scrive sul fronte di salita del clock, ma l'uscita è stabile solo dopo un piccolo ritardo, $t_"reg"$, il tempo per attraversare le porte dello slave. Da lì fino al fronte di salita successivo l'uscita *non cambia*.],
))

#figura(canvas(length: 0.8cm, {
  import draw: *
  line((0, 0.9), (1.8, 0.9), (1.8, 1.4), (3.8, 1.4), (3.8, 0.9), (5.8, 0.9), (5.8, 1.4), (7.8, 1.4), (7.8, 0.9), (8.6, 0.9), stroke: 1.2pt + blu)
  content((-0.7, 1.15), text(9pt)[clock])
  for (a, b, t) in ((0, 1.8, [vecchio]), (2.3, 5.8, [nuovo valore]), (6.3, 8.6, [⋯])) {
    rect((a, 0), (b, 0.5), stroke: 0.8pt + blu); content(((a + b) / 2, 0.25), text(8pt, t))
  }
  for x in (1.8, 5.8) { rect((x, 0), (x + 0.5, 0.5), fill: luma(225), stroke: none); line((x, 1.6), (x, -0.2), stroke: (dash: "dashed")) }
  content((-0.7, 0.25), $Q$)
  content((2.05, -0.45), text(8pt)[$t_"reg"$])
  line((2.3, -0.4), (5.8, -0.4), mark: (start: "stealth", end: "stealth")); content((4.05, -0.75), text(8pt)[$Q$ non cambia])
}), [Dopo il fronte di salita il registro è stabile per tutto il ciclo])

#video("14", "04:15", "08:21")Il latch SR si può anche simulare in Verilog: si scrive con le porte, e le uscite incrociate sono fili. Le forme d'onda del latch SR viste prima sono quelle che dà gtkwave simulandolo.

```verilog
module SR(output q, output notq, input s, input r);
  wire w1, w2, nw1, nw2;
  or(w1, r, nw2);   not(nw1, w1);     // NOR in alto
  or(w2, s, nw1);   not(nw2, w2);     // NOR in basso
  assign q = nw1;
  assign notq = nw2;
endmodule
```

== Reti sequenziali

#video("14", "17:38", "20:05")Con i registri una rete può ricordare qualcosa fra un ciclo di clock e l'altro. Ecco un problema dove serve: arriva una sequenza di bit, uno alla volta, e dopo ogni bit si vuole sapere se finora si è visto un numero *pari* di 1 (uscita 1) o dispari (uscita 0). È la *parità* della sequenza. Una rete combinatoria non basta, perché vede solo il bit di adesso. D'altra parte non serve ricordare tutta la sequenza: basta sapere se finora gli 1 sono pari o dispari, e ogni bit nuovo aggiorna questa informazione. Quello che la rete deve ricordare del passato è il suo *stato*: qui gli stati sono due, $S_0$ (pari) e $S_1$ (dispari).

Gli stati, con le frecce che dicono in che stato si va a seconda dell'ingresso, formano un *automa*. Una *rete sequenziale* è una rete che realizza un automa. In un *automa di Moore* l'uscita dipende *solo dallo stato*, e si scrive dentro lo stato.

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  figura(canvas(length: 0.8cm, {
    import draw: *
    let stato(p, nome, u) = {
      circle(p, radius: 0.6, fill: azzurro)
      content((p.at(0), p.at(1) + 0.22), nome); line((p.at(0) - 0.55, p.at(1)), (p.at(0) + 0.55, p.at(1)), stroke: 0.5pt)
      content((p.at(0), p.at(1) - 0.25), u)
    }
    stato((0, 0), $S_0$, [1]); circle((0, 0), radius: 0.72)
    stato((4, 0), $S_1$, [0])
    bezier((0.5, 0.55), (3.5, 0.55), (2, 1.6), mark: (end: "stealth")); content((2, 1.35), [1])
    bezier((3.5, -0.55), (0.5, -0.55), (2, -1.6), mark: (end: "stealth")); content((2, -1.35), [1])
    bezier((-0.65, -0.35), (-0.65, 0.35), (-2, -1), (-2, 1), mark: (end: "stealth")); content((-1.75, 0), [0])
    bezier((4.65, 0.35), (4.65, -0.35), (6, 1), (6, -1), mark: (end: "stealth")); content((5.75, 0), [0])
  }), [Automa di Moore: nello stato sopra il nome, sotto l'uscita. \ $S_0$ (doppio cerchio) è lo stato iniziale]),
  [
    - $S_0$ = pari, uscita 1; $S_1$ = dispari, uscita 0.
    - Un 0 non cambia la parità: si resta nello stesso stato.
    - Un 1 la cambia: si passa all'altro stato.
  ],
))

#let seq = (1, 0, 1, 1, 1, 0, 0, 0, 1)
#let stati = seq.fold((0,), (s, b) => s + (calc.rem(s.last() + b, 2),))
#align(center, table(columns: 11, align: center, inset: 5pt,
  [ciclo], ..range(10).map(k => [#k]),
  [stato], ..stati.map(s => [$S_#s$]),
  [uscita], ..stati.map(s => text(fill: blu, weight: "bold")[#(1 - s)]),
  [ingresso], ..seq.map(b => [#b]), [−],
))

#video("14", "20:06", "27:19")L'automa si descrive con due funzioni:

- la *funzione di transizione* $S'$ (o $sigma$): dato lo stato e l'ingresso, dà il prossimo stato. Va da stato × ingresso a stato;
- la *funzione delle uscite* $Z$ (o $omega$): dato lo stato, dà l'uscita.

Codificando $S_0 = 0$ e $S_1 = 1$, diventano tabelle di verità, quindi reti combinatorie:

#block(breakable: false, align(center, grid(columns: 3, gutter: 3em, align: horizon,
  tvb(($S$, $I$), ($S'$, b => calc.rem(b.sum(), 2))),
  [$ S' = overline(S) I + S overline(I) \ O = overline(S) $],
  tvb(($S$,), ($O$, b => 1 - b.at(0))),
)))

Manca un posto dove tenere lo stato: è un *registro*. Lo schema di una rete di Moore è sempre lo stesso: la rete $S'$ calcola il prossimo stato da ingresso e stato attuale, il registro lo memorizza al fronte di clock, e la rete $Z$ calcola l'uscita dal contenuto del registro.

#let schema-fsm(mealy: false) = canvas(length: 0.8cm, {
  import draw: *
  let blocco(x, t) = { rect((x, -0.5), (x + 1.4, 0.5), fill: azzurro); content((x + 0.7, 0), t) }
  content((-0.9, 0.2), $I$); fr((-0.6, 0.2), (1, 0.2))
  blocco(1, $S'$)
  fr((2.4, 0), (3.4, 0))
  rect((3.4, -0.5), (4.4, 0.5), fill: rgb("#fff3c4")); content((3.9, -0.1), $R$)
  line((3.75, 0.5), (3.9, 0.3), (4.05, 0.5)); line((3.9, 1.1), (3.9, 0.5), stroke: (dash: "dashed"))
  content((3.9, 1.35), text(8pt)[clock])
  fr((4.4, 0), (5.6, 0)); blocco(5.6, $Z$)
  fr((7, 0), (7.7, 0)); content((8, 0), $O$)
  circle((5, 0), radius: 0.05, fill: black)
  line((5, 0), (5, -1.1), (0.5, -1.1), (0.5, -0.2)); fr((0.5, -0.2), (1, -0.2))
  if mealy {
    circle((0, 0.2), radius: 0.05, fill: black)
    line((0, 0.2), (0, 1.9), (6.3, 1.9), stroke: red); fr((6.3, 1.9), (6.3, 0.5), stroke: red)
  }
})
#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  figura(schema-fsm(), [Rete di Moore]),
  [Per la parità: $S'$ sono due AND e un OR ($2 Delta t$), il registro ha 1 bit, $Z$ è un NOT ($0$). Il registro ha WE = 1: a ogni ciclo di clock arriva un ingresso, e lo stato va sempre aggiornato.],
))

#figura(rete-sp(($S$, $I$), ((0, 1), (1, 0)), uscita: $S'$), [La rete $S'$ della parità; il suo ingresso $S$ è l'uscita del registro])

#video("14", "27:20", "32:35")A ogni ciclo di clock si presenta un bit della sequenza. All'inizio del ciclo il registro ha già il suo valore e l'ingresso $I$ resta fermo per tutto il ciclo: c'è il tempo di calcolare il nuovo stato, che si scrive nel registro al fronte successivo, e l'uscita.

#block(sticky: true)[Il progetto di una rete sequenziale segue cinque passi:]

#block(breakable: false, width: 100%, align(center, text(9pt, stack(dir: ltr, spacing: 0.5em,
  box(stroke: 0.6pt, inset: 7pt)[1. automa], align(horizon)[→],
  box(stroke: 0.6pt, inset: 7pt, fill: azzurro)[2. reti combinatorie \ $S'$ e $Z$], align(horizon)[→],
  box(stroke: 0.6pt, inset: 7pt, fill: rgb("#fff3c4"))[3. registro di stato \ #text(8pt)[bit per tutti gli stati]], align(horizon)[→],
  box(stroke: 0.6pt, inset: 7pt)[4. schema \ strutturale], align(horizon)[→],
  box(stroke: 0.6pt, inset: 7pt)[5. ciclo \ di clock $tau$],
))))

Il registro deve avere abbastanza bit per numerare tutti gli stati: 2 stati, 1 bit; 4 stati, 2 bit. Il *ciclo di clock* $tau$ deve bastare perché si stabilizzino *tutte e due* le reti, più il tempo di scrittura del registro:

$ tau = max(T_(S'), T_Z) + t_"reg" #h(3em) "parità:" quad tau = max(2 Delta t, 0) + t_"reg" = 2 Delta t + t_"reg" $

#nota[Con un clock più corto si scriverebbe nel registro un valore non ancora stabile, oppure il registro cambierebbe mentre l'uscita si sta ancora calcolando, e l'uscita non si stabilizzerebbe mai.]

#video("14", "32:37", "34:53")In un *automa di Mealy* invece l'uscita dipende dallo stato *e dall'ingresso*: le uscite si scrivono sulle frecce, non negli stati. Lo schema è lo stesso, ma l'ingresso entra anche nella rete $Z$:

#figura(schema-fsm(mealy: true), [Rete di Mealy: in rosso il collegamento in più])

#let stato-m(p, nome, iniziale: false) = {
  import draw: *
  circle(p, radius: 0.45, fill: azzurro); content(p, nome)
  if iniziale { circle(p, radius: 0.55) }
}
// freccia curva da a a b: piega > 0 la curva a sinistra di chi va da a verso b
#let arco(a, b, t, piega: 0.5) = {
  import draw: *
  let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1))
  let l = calc.sqrt(dx * dx + dy * dy)
  let (ux, uy) = (dx / l, dy / l)
  let (nx, ny) = (-uy, ux)
  let s = if piega >= 0 { 1 } else { -1 }
  let p0 = (a.at(0) + 0.5 * (0.8 * ux + 0.6 * s * nx), a.at(1) + 0.5 * (0.8 * uy + 0.6 * s * ny))
  let p1 = (b.at(0) + 0.5 * (-0.8 * ux + 0.6 * s * nx), b.at(1) + 0.5 * (-0.8 * uy + 0.6 * s * ny))
  let (mx, my) = ((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2)
  bezier(p0, p1, (mx + 2 * piega * nx, my + 2 * piega * ny), mark: (end: "stealth"))
  content((mx + (piega + 0.4 * s) * nx, my + (piega + 0.4 * s) * ny), text(8pt, t))
}
// freccia che torna nello stesso stato, sopra o sotto
#let anello(p, t, su: true) = {
  import draw: *
  let s = if su { 1 } else { -1 }
  let (x, y) = p
  bezier((x - 0.25, y + s * 0.38), (x + 0.25, y + s * 0.38), (x - 0.7, y + s * 1.4), (x + 0.7, y + s * 1.4), mark: (end: "stealth"))
  content((x, y + s * 1.45), text(8pt, t))
}

#video("16", "01:13", "07:25")Per esempio la parità con un automa di Mealy. Gli stati restano due, $S_0$ pari e $S_1$ dispari, ma l'uscita si scrive sulla freccia, dopo l'ingresso: "1/0" vuol dire "arriva un 1, l'uscita è 0". Da $S_0$ un 0 lascia la parità pari: si resta in $S_0$ con uscita 1; un 1 la rende dispari: si va in $S_1$ con uscita 0. Da $S_1$ è lo stesso al contrario.

#let seq-m = (0, 1, 0, 0, 1, 0, 1)
#let stati-m = seq-m.fold((0,), (s, b) => s + (calc.rem(s.last() + b, 2),))
#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  figura(canvas(length: 0.8cm, {
    import draw: *
    stato-m((0, 0), $S_0$, iniziale: true); stato-m((4, 0), $S_1$)
    arco((0, 0), (4, 0), [1/0]); arco((4, 0), (0, 0), [1/1])
    anello((0, 0), [0/1]); anello((4, 0), [0/0])
  }), [Automa di Mealy per la parità: \ sulle frecce ingresso/uscita]),
  [
    #align(center, table(columns: 8, align: center, inset: 5pt,
      [ciclo], ..range(7).map(k => [#k]),
      [stato], ..stati-m.slice(0, 7).map(s => [$S_#s$]),
      [ingresso], ..seq-m.map(b => [#b]),
      [uscita], ..stati-m.slice(1).map(s => text(fill: blu, weight: "bold")[#(1 - s)]),
    ))
    Qui l'uscita di ogni ciclo conta già il bit appena arrivato.
  ],
))

Codificando $S_0 = 0$, $S_1 = 1$, una sola tabella dà tutte e due le funzioni, perché ora anche l'uscita dipende da stato e ingresso:

#block(breakable: false, align(center, grid(columns: 2, gutter: 3em, align: horizon,
  tvb(($S$, $I$), ($S'$, b => calc.rem(b.sum(), 2)), ($O$, b => 1 - calc.rem(b.sum(), 2))),
  [$ S' &= overline(S) I + S overline(I) \ O &= overline(S) thin overline(I) + S I $
   Lo schema è quello di Mealy qui sopra, con un registro da 1 bit. \
   $ tau = max(T_(S'), T_Z) + t_"reg" = max(2 Delta t, 2 Delta t) + t_"reg" = 2 Delta t + t_"reg" $],
)))

Gli automi di Mealy di solito sono più compatti: un automa di Moore per lo stesso problema ha lo stesso numero di stati o qualcuno in più.

#video("16", "07:31", "15:00")Un uso tipico degli automi è *riconoscere una stringa*: arriva un simbolo per ciclo, e l'uscita vale 1 quando gli ultimi simboli formano la stringa cercata. Esempio: riconoscere $a b b a$ sull'alfabeto ${a, b}$, senza sovrapposizioni (l'$a$ finale di un $a b b a$ non conta come inizio del successivo). Ogni stato ricorda quanta parte della stringa si è già vista: $S_0$ niente, $S_1$ "$a$", $S_2$ "$a b$", $S_3$ "$a b b$".

#figura(canvas(length: 0.8cm, {
  import draw: *
  for (k, x) in (0, 3, 6, 9).enumerate() { stato-m((x, 0), $S_#k$, iniziale: k == 0) }
  anello((0, 0), [$b$/0]); anello((3, 0), [$a$/0])
  arco((0, 0), (3, 0), [$a$/0]); arco((3, 0), (6, 0), [$b$/0]); arco((6, 0), (3, 0), [$a$/0]); arco((6, 0), (9, 0), [$b$/0])
  arco((9, 0), (0, 0), [$b$/0], piega: 1.4); arco((9, 0), (0, 0), [$a$/#strong[1]], piega: 2.3)
}), [Riconoscitore di $a b b a$ (Mealy)])

- Una $a$ quando si aspettava una $b$ non butta via tutto: quella $a$ può essere l'inizio della stringa, quindi si va (o si resta) in $S_1$.
- In $S_3$ una $b$ fa $a b b b$: si riparte da capo. Una $a$ completa $a b b a$: uscita 1, l'unica dell'automa, e si torna in $S_0$.

Con Moore l'uscita sta negli stati, quindi serve uno stato in più: $S_4$, "ho appena visto $a b b a$", l'unico con uscita 1. Da lì si riparte: una $a$ è l'inizio di una nuova stringa e porta in $S_1$, una $b$ riporta in $S_0$.

#figura(canvas(length: 0.75cm, {
  import draw: *
  for (k, x) in (0, 2.6, 5.2, 7.8, 10.4).enumerate() {
    circle((x, 0), radius: 0.58, fill: azzurro); line((x - 0.56, -0.05), (x + 0.56, -0.05), stroke: 0.5pt)
    content((x, 0.24), text(9pt, $S_#k$)); content((x, -0.3), text(9pt, if k == 4 { strong[1] } else [0]))
    if k == 0 { circle((x, 0), radius: 0.68) }
  }
  anello((0, 0), [$b$]); anello((2.6, 0), [$a$])
  arco((0, 0), (2.6, 0), [$a$]); arco((2.6, 0), (5.2, 0), [$b$]); arco((5.2, 0), (7.8, 0), [$b$]); arco((7.8, 0), (10.4, 0), [$a$])
  arco((5.2, 0), (2.6, 0), [$a$], piega: 0.3); arco((7.8, 0), (0, 0), [$b$], piega: 1.3)
  arco((10.4, 0), (2.6, 0), [$a$], piega: 2.1); arco((10.4, 0), (0, 0), [$b$], piega: 2.9)
}), [Riconoscitore di $a b b a$ (Moore): nello stato sopra il nome, sotto l'uscita])

Per provare i due automi si possono seguire $a b b a a b b a$ (riconosciuta due volte), $a b a b a b b a$ e $a b b a b a b$ (una volta ciascuna).

Per la rete di Mealy si codificano gli stati col loro numero in due bit $s_1 s_0$ ($S_2 = 10$), $a = 0$ e $b = 1$ nell'ingresso $x$:

#let abba = ((1, 0), (1, 2), (1, 3), (0, 0))   // prossimo stato con a e con b
#let prossimo(b) = abba.at(b.at(0) * 2 + b.at(1)).at(b.at(2))
#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  tvb(($s_1$, $s_0$, $x$), ($s'_1$, b => calc.quo(prossimo(b), 2)), ($s'_0$, b => calc.rem(prossimo(b), 2)),
    ($z$, b => if b == (1, 1, 0) { 1 } else { 0 })),
  [
    $ z &= s_1 s_0 overline(x) \
      s'_1 &= overline(s_1) s_0 x + s_1 overline(s_0) x \
      s'_0 &= s_1 overline(s_0) + overline(s_1) thin overline(x) $
    $z$ ha un solo 1: un solo AND, niente OR. In $s'_1$ i due 1 non si raccolgono. In $s'_0$ ci sono quattro 1: 100 e 101 differiscono solo per $x$ e danno $s_1 overline(s_0)$; 000 e 010 differiscono solo per $s_0$ e danno $overline(s_1) thin overline(x)$.
  ],
))

== Reti sequenziali coi componenti e in Verilog

Una rete sequenziale si può anche costruire direttamente con i componenti già visti, come si è fatto per le reti combinatorie con l'approccio strutturale.

#video("16", "15:23", "29:46")Esempio: uno stanzino con una sola porta, da cui passa una persona alla volta, con posto per due persone. Due ingressi: *in* vale 1 se entra una persona, *out* vale 1 se ne esce una. L'uscita $z$ comanda la lampadina: 1 accesa, 0 spenta. La luce deve restare accesa finché dentro c'è qualcuno. Sulle frecce dell'automa (di Mealy) ci sono i due ingressi *in out*, poi l'uscita; − vuol dire che quel bit non conta.

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  figura(canvas(length: 0.8cm, {
    import draw: *
    stato-m((0, 0), $S_0$, iniziale: true); stato-m((4, 0), $S_1$); stato-m((8, 0), $S_2$)
    anello((0, 0), [0−/0]); anello((4, 0), [00/1]); anello((4, 0), [11/1], su: false); anello((8, 0), [00/1])
    arco((0, 0), (4, 0), [10/1]); arco((4, 0), (0, 0), [01/0]); arco((4, 0), (8, 0), [10/1]); arco((8, 0), (4, 0), [01/1])
    for (x, t) in ((0, [vuoto, \ luce spenta]), (4, [1 persona]), (8, [2 persone])) { content((x, -2.3), text(8pt, t)) }
  }), [Lo stanzino]),
  [
    - In $S_1$ con 11 uno esce e un altro entra: dentro resta una persona.
    - Mancano i casi che non possono capitare: da $S_0$ non può uscire nessuno, in $S_2$ non può entrare nessuno.
  ],
))

Quello che l'automa ricorda è *quante persone ci sono*: è un contatore. Allora si può costruire così:

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  figura(canvas(length: 0.8cm, {
    import draw: *
    let tratt = (dash: "dashed", paint: red)
    trap((0, 0), w: 4, etichette: ("00", "01", "10", "11"))
    line((0.5, 2.4), (4.8, 2.4)); circle((0.5, 2.4), radius: 0.05, fill: black)
    for x in (0.5, 3.5) { fr((x, 2.4), (x, 0)) }
    for (x, t) in ((1.5, [−1]), (2.5, [+1])) {
      circle((x, 2.4), radius: 0.05, fill: black); fr((x, 2.4), (x, 1.75))
      rect((x - 0.35, 1.75), (x + 0.35, 1.15), fill: white); content((x, 1.45), text(8pt, t)); fr((x, 1.15), (x, 0))
    }
    fr((-1.1, -0.35), (0.15, -0.35)); content((-1.3, -0.35), anchor: "east", text(9pt)[in out]); bus((-0.45, -0.35), [2])
    fr((2, -0.7), (2, -1.3))
    rect((1.2, -1.3), (2.8, -2), fill: rgb("#fff3c4")); content((2, -1.65), text(9pt)[registro])
    fr((0.2, -1.65), (1.2, -1.65)); content((0.05, -1.65), anchor: "east", text(8pt)[WE = 1])
    line((2, -2), (2, -3.65)); circle((2, -2.5), radius: 0.05, fill: black); line((2, -2.5), (4.8, -2.5), (4.8, 2.4))
    circle((2, -3.25), radius: 0.05, fill: black)
    line((2, -3.25), (2.4, -3.25)); line((2, -3.65), (2.4, -3.65))
    content((1.6, -3.25), text(7pt)[$b_1$]); content((1.6, -3.65), text(7pt)[$b_0$])
    porta-or((2.4, -3.45), h: 0.8); line((3.28, -3.45), (3.9, -3.45)); content((4.2, -3.45), $z$)
    rect((-0.3, 2.75), (5.1, -0.9), stroke: tratt); content((5.3, 1.5), anchor: "west", text(8pt, fill: red)[prossimo \ stato])
    rect((1, -1.15), (3, -2.15), stroke: tratt); content((5.3, -1.65), anchor: "west", text(8pt, fill: red)[registro \ di stato])
    rect((1.3, -2.9), (4.5, -4.05), stroke: tratt); content((5.3, -3.45), anchor: "west", text(8pt, fill: red)[uscite])
  }), [Lo stanzino coi componenti. In rosso \ le tre parti di una rete sequenziale]),
  [
    - Il registro ha 2 bit, quanti ne servono per contare 0, 1, 2.
    - Un MUX a 4 ingressi, comandato da *in out*, sceglie il prossimo valore: 00 e 11 lo lasciano com'è, 01 toglie 1, 10 aggiunge 1. $+1$ e $-1$ sono gli `x++` e `x--` fatti con un sommatore.
    - La luce è accesa se il contatore è 1 o 2, cioè se almeno un bit vale 1: $z = b_1 + b_0$, una OR.
  ],
))

Funziona perché i casi impossibili non capitano: $-1$ arriva solo se qualcuno esce, quindi il contatore non va sotto 0, e $+1$ non lo porta oltre 2. È un modo "algoritmico" di fare una rete sequenziale: si pensa a cosa va ricordato e a come cambia, e si collegano componenti già pronti.

Che rete è, di Mealy o di Moore? Gli ingressi *in out* arrivano solo alla parte che calcola il prossimo stato; l'OR vede solo il registro. L'uscita dipende solo dallo stato: è una rete di *Moore*.

#video("16", "29:54", "39:12")Ultimo esempio: chiudere le porte di un'aula dopo $k$ ingressi. Ogni volta che entra una persona arriva $x = 1$ (le uscite non si contano). L'uscita $z$ vale 0 con le porte aperte e 1 per chiuderle.

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  figura(canvas(length: 0.8cm, {
    import draw: *
    rect((0, 0), (2, 0.8), fill: azzurro); content((1, 0.4), text(9pt)[sommatore])
    content((1.5, 1.85), $x$); fr((1.5, 1.6), (1.5, 0.8))
    fr((1, 0), (1, -1.4)); bus((1, -0.7), [8])
    rect((0, -1.4), (2, -2.2), fill: rgb("#fff3c4")); content((1, -1.8), text(9pt)[registro])
    line((0.6, -2.2), (0.6, -3.4), mark: (end: "stealth")); circle((0.6, -2.7), radius: 0.05, fill: black)
    line((0.6, -2.7), (-0.8, -2.7), (-0.8, 1.2), (0.5, 1.2)); fr((0.5, 1.2), (0.5, 0.8))
    content((1.75, -2.6), text(8pt)[200]); fr((1.4, -2.75), (1.4, -3.4))
    rect((0, -3.4), (2, -4.2), fill: azzurro); content((1, -3.8), [=])
    fr((1, -4.2), (1, -5)); content((1, -5.3), $z$)
    circle((1, -4.6), radius: 0.05, fill: black); line((1, -4.6), (3.2, -4.6), (3.2, -1.8), (2.16, -1.8)); circle((2.08, -1.8), radius: 0.08)
    content((2.65, -1.55), text(8pt)[WE])
  }), [Le porte dopo 200 ingressi]),
  [
    - *Stato*: quante persone sono entrate. Per contare fino a $k$ il registro ha $ceil(log_2 k)$ bit; per $k = 200$, siccome $2^7 = 128 < 200 <= 256 = 2^8$, ne servono 8.
    - *Uscita*: un comparatore fra il registro e la costante 200, cioè fili fissi a 11001000. Dà 1 quando il registro arriva a 200, e le porte si chiudono.
    - *Prossimo stato*: si potrebbe usare un MUX comandato da $x$ fra registro + 1 e registro + 0. Più semplice: un sommatore che fa registro + $x$. Con $x = 1$ aggiunge 1, con $x = 0$ lascia il valore com'è.
  ],
))

Resta un problema: a porte chiuse $x = 1$ non dovrebbe più arrivare, ma se arriva lo stesso il registro passa a 201, il comparatore torna a 0 e le porte si riaprono. Si blocca il registro: il WE non è più 1 fisso, ma $overline(z)$. Finché $z = 0$ il registro si scrive; quando $z = 1$ resta fermo a 200. Anche questa è una rete di Moore: $x$ entra solo nel sommatore, e $z$ dipende solo dal registro.

#video("1718", "09:11", "17:43")Una rete sequenziale si può provare in Verilog come una combinatoria. Il primo modo, *strutturale*, ricopia lo schema di Moore o di Mealy pezzo per pezzo: le reti $S'$ e $Z$ si scrivono come si è già visto, con una `primitive` o con `assign`; il registro è un modulo nuovo; le frecce dello schema diventano fili (`wire`). Per la parità di Moore, con $S_0 = 0$ e $S_1 = 1$, le due reti combinatorie sono le tabelle di $S'$ e di $O$ viste prima:

```verilog
primitive s1(output z, input s, input x);   // S': prossimo stato
  table
  // s x : z
     0 0 : 0;
     0 1 : 1;
     1 0 : 1;
     1 1 : 0;
  endtable
endprimitive

module uscita(output z, input s);           // Z: l'uscita è il NOT dello stato
  assign z = !s;
endmodule
```

#video("1718", "17:45", "24:11")Il registro deve fare quello che fa il registro coi flip-flop: al fronte di salita del clock, se WE = 1, scrive l'ingresso; per tutto il resto del tempo l'uscita è il valore scritto. Ha un parametro N, il numero di bit.

```verilog
module registro #(parameter N = 2)
                (output [N-1:0] z, input clock, input enable, input [N-1:0] inval);
  reg [N-1:0] stato;            // N flip-flop: qui sta il valore
  initial
    begin
      stato = 0;                // all'accensione vale 0
    end
  always @(posedge clock)       // a ogni fronte di salita del clock...
    begin
      if (enable)
        stato <= inval;         // ...se WE = 1 scrive l'ingresso
    end
  assign z = stato;             // l'uscita è sempre il contenuto
endmodule
```

#block(breakable: false, grid(columns: (1fr, auto), gutter: 2em, align: horizon,
  [
    - `reg` è proprio un registro: Verilog lo costruisce con dei flip-flop. Nel test si usava per gli ingressi perché il test ci scrive un valore e lo tiene.
    - `initial` si esegue una volta sola, quando il modulo si accende.
    - `always @(...)` esegue il blocco ogni volta che cambia qualcosa nella lista fra parentesi. `posedge clock` vuol dire "quando il clock passa da 0 a 1" (fronte di salita), `negedge clock` "quando passa da 1 a 0" (fronte di discesa).
    - Quando cambia `stato` cambia anche `z`: subito dopo il fronte l'uscita è il valore appena scritto.
  ],
  figura(canvas(length: 0.8cm, {
    import draw: *
    line((0, 0), (1, 0), (1, 1), (2.2, 1), (2.2, 0), (3.2, 0), stroke: 1.2pt + blu)
    content((1, 2), text(8pt, fill: red)[posedge]); fr((1, 1.8), (1, 1.1), stroke: red)
    content((2.2, -0.9), text(8pt, fill: red)[negedge]); fr((2.2, -0.7), (2.2, -0.1), stroke: red)
    content((-0.5, 0.5), text(9pt)[clock])
  }), [I due fronti del clock]),
))

#nota[Nel corso si suppone che registri e memorie, all'accensione, valgano 0. Nei componenti veri serve un segnale apposta; in Verilog lo fa `initial`.]

#video("1718", "24:11", "34:23")Ora i tre pezzi si collegano come nello schema di Moore, dentro un modulo `pari` che ha come parametri solo quello che sta fuori: l'ingresso $x$, il clock e l'uscita $z$. Il WE non c'è, perché in una rete sequenziale il registro si scrive a ogni ciclo: è fisso a 1, la costante `1'b1`. Dentro servono due fili (in rosso nel disegno): `w1` porta il prossimo stato al registro, `w2` porta il contenuto del registro all'uscita *e* di nuovo al prossimo stato. Un filo che arriva in due posti è sempre lo stesso filo. Sotto ogni blocco c'è il nome della sua copia nel codice.

#figura(canvas(length: 0.8cm, {
    import draw: *
    let blocco(x0, x1, t, nome, colore: azzurro) = {
      rect((x0, -0.45), (x1, 0.45), fill: colore); content(((x0 + x1) / 2, 0), text(9pt, t))
      content(((x0 + x1) / 2, -0.75), text(7pt, nome))
    }
    blocco(0, 1.6, `s1`, `prossimostato`); blocco(2.6, 4.6, `registro`, `rstato`, colore: rgb("#fff3c4")); blocco(5.7, 7.3, `uscita`, `funz`)
    content((-1.2, 0.2), $x$); fr((-0.95, 0.2), (0, 0.2))
    fr((1.6, 0), (2.6, 0), stroke: red); content((2.1, 0.3), text(8pt, fill: red)[`w1`])
    fr((4.6, 0), (5.7, 0), stroke: red); content((5.15, 0.3), text(8pt, fill: red)[`w2`])
    circle((5.15, 0), radius: 0.05, fill: red)
    line((5.15, 0), (5.15, -1.2), (-0.4, -1.2), (-0.4, -0.2), stroke: red); fr((-0.4, -0.2), (0, -0.2), stroke: red)
    line((3.6, 1.4), (3.6, 0.45), stroke: (dash: "dashed")); content((3.6, 1.65), text(8pt)[clock])
    fr((7.3, 0), (8.1, 0)); content((8.35, 0), $z$)
    rect((-0.7, -1.5), (7.7, 1.2), stroke: verde); content((-0.3, 0.95), text(8pt, fill: verde)[`pari`])
  }), [La parità di Moore in Verilog])

```verilog
module pari(output z, input clock, input x);
  wire w1, w2;
  s1 prossimostato(w1, w2, x);
  uscita funz(z, w2);
  registro #(1) rstato(w2, clock, 1'b1, w1);
endmodule
```

Come per il full adder, ogni riga crea una copia di un modulo e la collega, nell'ordine dei parametri: `prossimostato` legge lo stato da `w2` e $x$ e scrive su `w1`; `rstato` è un registro da 1 bit (`#(1)`) che legge `w1` e scrive su `w2`. Per una rete di Mealy l'unica differenza è che anche `uscita` riceve $x$.

#video("1718", "37:20", "38:24")Per provarla si scrive un test come per le reti combinatorie, con in più il clock. Lo genera un `always` senza lista, che si ripete per sempre:

```verilog
always #1 clock = ~clock;      // ogni unità di tempo si inverte: 0, 1, 0, 1...
```

#video("1718", "40:31", "46:22")È la stessa idea del MUX a quattro fatto con tre MUX a due: si prendono i pezzi e si collegano coi fili. Lì i pezzi erano tutti reti combinatorie, qui due combinatorie e un registro. In Verilog `c[0]` è il bit meno significativo, quello che sceglie dentro le coppie (nella sezione sui componenti si chiamava $c_1$), e `c[1]` sceglie la coppia.

```verilog
module mux(output z, input x, input y, input c);
  assign z = (!c && x) || (c && y);
endmodule

module mux4(output z, input x0, input x1, input x2, input x3, input [1:0] c);
  wire f1, f2;
  mux A(f1, x0, x1, c[0]);     // sceglie dentro la prima coppia
  mux B(f2, x2, x3, c[0]);     // sceglie dentro la seconda coppia
  mux C(z, f1, f2, c[1]);      // sceglie quale coppia esce
endmodule
```

#video("1718", "46:53", "53:13")Scrivere a mano ogni modulo e ogni filo è lungo. Il secondo modo, *behavioural* (cioè "che descrive il comportamento"), scrive quasi come in C cosa fa la rete, e i componenti li ricava Verilog. Lo schema da descrivere è sempre lo stesso: una formula per $S'$, una per $Z$, e il registro. Tutto in un modulo:

```verilog
module fsm(output z, input clock, input x);
  reg stato;                      // il registro di stato
  reg nuovostato;                 // il prossimo stato, appena calcolato
  initial
    begin
      stato <= 0;
      nuovostato <= 0;
    end
  always @(stato, x)              // ogni volta che cambia lo stato o l'ingresso...
    begin
      nuovostato <= ...;          // ...ricalcola S' (la sua formula)
    end
  always @(posedge clock)         // al fronte di salita il nuovo stato
    stato <= nuovostato;          // entra nel registro
  assign z = ...;                 // la formula di Z
endmodule
```

Servono due `reg` perché il prossimo stato si calcola appena cambiano ingresso o stato, ma non deve entrare subito nel registro: solo al fronte di salita del clock. In `initial` basterebbe dare il valore a `stato`; `nuovostato` viene calcolato subito. Con una sola istruzione, come nel secondo `always`, `begin` ed `end` si possono omettere.

Dentro `initial` e `always` si assegna con `=` o con `<=`. Con `=` gli assegnamenti avvengono uno dopo l'altro, come in C: `a = 0; b = a & c;` dà sempre $b = 0$. Con `<=` avvengono *contemporaneamente*, e ognuno usa i valori di prima: `a <= 0; b <= a & c;` mette in $b$ l'AND fra il vecchio $a$ e $c$. Per i registri dello stato si usa `<=`: cambiano tutti insieme, come i flip-flop veri.

#video("1718", "56:20", "57:21")Da un modulo scritto così, Quartus (lo strumento di Intel per le FPGA, più grande di Icarus Verilog) ricava da solo la rete di componenti, e sa anche ridisegnare l'automa da cui si era partiti.

#nota[#video("1718", "57:25", "58:49")*Due modi per una rete sequenziale in Verilog.* *Strutturale*: si prende il disegno della rete e lo si ricopia coi moduli, collegati da fili. *Behavioural*: un modulo con il registro di stato e un registro "ombra" per il nuovo stato; un `always @(stato, ingressi)` ricalcola il nuovo stato, un `always @(posedge clock)` lo copia nello stato, e `assign` calcola le uscite dallo stato e dagli ingressi se la rete è di Mealy, dal solo stato se è di Moore.]

Un esempio completo nei due modi: riconoscere $a b a$ sull'alfabeto ${a, b}$, senza sovrapposizioni. È come $a b b a$, con uno stato in meno: $S_0$ non ha visto niente, $S_1$ ha visto "$a$", $S_2$ ha visto "$a b$".

#let aba = ((1, 0), (1, 2), (0, 0))   // prossimo stato con a e con b
#let aba-p(b) = if b.at(0) == 1 and b.at(1) == 1 { none } else { aba.at(b.at(0) * 2 + b.at(1)).at(b.at(2)) }
#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  figura(canvas(length: 0.8cm, {
    import draw: *
    for (k, x) in (0, 3, 6).enumerate() { stato-m((x, 0), $S_#k$, iniziale: k == 0) }
    anello((0, 0), [$b$/0]); anello((3, 0), [$a$/0])
    arco((0, 0), (3, 0), [$a$/0]); arco((3, 0), (6, 0), [$b$/0])
    arco((6, 0), (0, 0), [$b$/0], piega: 1.1); arco((6, 0), (0, 0), [$a$/#strong[1]], piega: 1.9)
  }), [Riconoscitore di $a b a$ (Mealy)]),
  [
    - In $S_1$ un'altra $a$ può essere l'inizio della stringa: si resta in $S_1$.
    - In $S_2$ una $b$ fa $a b b$: si riparte da capo. Una $a$ completa $a b a$: uscita 1, e si torna in $S_0$, perché quell'$a$ non conta come inizio della prossima.
  ],
))

Si codificano gli stati col loro numero ($S_2 = 10$), $a = 0$ e $b = 1$. Lo stato 11 non esiste: le sue righe non contano (−).

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  tvb(($s_1$, $s_0$, $x$),
    ($s'_1$, b => if aba-p(b) == none [−] else { calc.quo(aba-p(b), 2) }),
    ($s'_0$, b => if aba-p(b) == none [−] else { calc.rem(aba-p(b), 2) }),
    ($z$, b => if aba-p(b) == none [−] else if b == (1, 0, 0) { 1 } else { 0 })),
  [
    $ z &= s_1 overline(s_0) thin overline(x) \
      s'_1 &= overline(s_1) s_0 x \
      s'_0 &= overline(s_1) thin overline(s_0) thin overline(x) + overline(s_1) s_0 overline(x) = overline(s_1) thin overline(x) $
    In $s'_0$ i due 1 differiscono solo per $s_0$, che quindi non conta: raccogliendo resta $overline(s_1) thin overline(x) (overline(s_0) + s_0) = overline(s_1) thin overline(x)$.
  ],
))

Nel modo strutturale ogni formula diventa un `assign`; il filo `toReg` va dal prossimo stato al registro, `fromReg` dal registro alle due reti, tutti e due da 2 bit. È una rete di Mealy, quindi anche `uscite` riceve l'ingresso.

```verilog
module uscite(output z, input in, input [1:0] s);
  assign z = (~in) && s[1] && (~s[0]);
endmodule

module stato(output [1:0] ns, input in, input [1:0] s);
  assign ns[1] = in && (~s[1]) && s[0];
  assign ns[0] = (~s[1]) && (~in);         // la forma semplificata
endmodule

module fsm(output z, input x, input clock);
  wire [1:0] toReg, fromReg;
  registro #(2) rst(fromReg, clock, 1'b1, toReg);
  uscite usc(z, x, fromReg);
  stato sta(toReg, x, fromReg);
endmodule
```

Nel modo behavioural si danno un nome agli stati e ai simboli con #raw("`define") (come `#define` in C; il nome si usa con l'apice rovesciato davanti, #raw("`S1")), e la funzione $S'$ si scrive con un `case` sullo stato, che ricopia le frecce dell'automa:

```verilog
`define S0 2'b00
`define S1 2'b01
`define S2 2'b10
`define A 1'b0
`define B 1'b1

module fsm(output z, input x, input clock);
  reg [1:0] stato;
  reg [1:0] nuovostato;
  initial
    begin
      stato = `S0;
    end
  always @(posedge clock)
    stato <= nuovostato;
  always @(stato, x)                         // la funzione S'
    begin
      case (stato)
        `S0: nuovostato <= (x == `A ? `S1 : `S0);
        `S1: nuovostato <= (x == `B ? `S2 : `S1);
        `S2: nuovostato <= (x == `B ? `S0 : `S0);   // comunque in S0
      endcase
    end
  assign z = ((stato == `S2 && x == `A) ? 1 : 0);   // la funzione Z
endmodule
```

I due moduli hanno gli stessi parametri, quindi lo stesso test li prova tutti e due. Qui il clock si inverte ogni 2 unità di tempo: sale a 2, 6, 10… Gli ingressi cambiano fra un fronte e l'altro, così al fronte sono già stabili.

```verilog
module test;
  reg x;                     // un reg per ogni ingresso del modulo da provare
  reg clock;
  wire z;                    // un wire per ogni uscita
  fsm my(z, x, clock);
  initial
    begin
      clock <= 0;
      x <= 0;
    end
  always
    #2 clock = ~clock;
  initial
    begin
      $dumpfile("test.vcd");
      $dumpvars;
      #0 x <= `B;            // la sequenza b a b a a b a
      #3 x <= `A;
      #4 x <= `B;
      #4 x <= `A;
      #8 x <= `B;
      #4 x <= `A;
      #8 $finish;
    end
endmodule
```

#let moore = ((1, 0), (1, 2), (3, 0), (1, 0))   // abA con Moore: S3 = "ho visto aba"
#let ab-n = 30
#let ab-x = range(ab-n).map(t => if t < 3 or (t >= 7 and t < 11) or (t >= 19 and t < 23) { 1 } else { 0 })
#let ab-c = clock(ab-n)
#let sale(i) = i > 0 and ab-c.at(i) == 1 and ab-c.at(i - 1) == 0
#let ab-me = sim(ab-n, (i, p) => if i == 0 { 0 } else if sale(i) { aba.at(p).at(ab-x.at(i)) } else { p })
#let ab-mo = sim(ab-n, (i, p) => if i == 0 { 0 } else if sale(i) { moore.at(p).at(ab-x.at(i)) } else { p })

Con Moore l'uscita sta negli stati, quindi serve uno stato in più, come per $a b b a$: $S_3$, "ho appena visto $a b a$", l'unico con uscita 1. Da $S_2$ una $a$ porta in $S_3$; da $S_3$ una $a$ è l'inizio di una nuova stringa e porta in $S_1$, una $b$ riporta in $S_0$. Il codice strutturale è lo stesso, cambiano le formule: $S_3 = 11$, quindi l'uscita è `assign z = s[1] && s[0];`, e non riceve più l'ingresso.

#block(breakable: false, grid(columns: (auto, 1fr), gutter: 2em, align: horizon,
  figura(canvas(length: 0.75cm, {
    import draw: *
    for (k, x) in (0, 2.6, 5.2, 7.8).enumerate() {
      circle((x, 0), radius: 0.58, fill: azzurro); line((x - 0.56, -0.05), (x + 0.56, -0.05), stroke: 0.5pt)
      content((x, 0.24), text(9pt, $S_#k$)); content((x, -0.3), text(9pt, if k == 3 { strong[1] } else [0]))
      if k == 0 { circle((x, 0), radius: 0.68) }
    }
    anello((0, 0), [$b$]); anello((2.6, 0), [$a$])
    arco((0, 0), (2.6, 0), [$a$]); arco((2.6, 0), (5.2, 0), [$b$]); arco((5.2, 0), (7.8, 0), [$a$])
    arco((5.2, 0), (0, 0), [$b$], piega: 1.2); arco((7.8, 0), (2.6, 0), [$a$], piega: -1.6); arco((7.8, 0), (0, 0), [$b$], piega: 2.2)
  }), [Riconoscitore di $a b a$ (Moore)]),
  tvb(($s_1$, $s_0$, $x$),
    ($s'_1$, b => calc.quo(moore.at(b.at(0) * 2 + b.at(1)).at(b.at(2)), 2)),
    ($s'_0$, b => calc.rem(moore.at(b.at(0) * 2 + b.at(1)).at(b.at(2)), 2))),
))

$ s'_1 = overline(s_1) s_0 x + s_1 overline(s_0) thin overline(x) #h(3em) s'_0 = overline(x) $

Per $s'_0$ gli 1 sono le quattro righe con $x = 0$: con una $a$ si va sempre in uno stato dispari ($S_1$ o $S_3$).

Ecco cosa mostra gtkwave per il test, con la rete di Mealy e con quella di Moore (le linee tratteggiate sono i fronti di salita del clock):

#figura(onde(w: 0.36, righe: fronti(ab-n), (
  ([clock], ab-c),
  ([$x$], ab-x),
  ([stato (Mealy)], ab-me.map(s => "S" + str(s))),
  ([$z$ (Mealy)], range(ab-n).map(i => if ab-me.at(i) == 2 and ab-x.at(i) == 0 { 1 } else { 0 })),
  ([stato (Moore)], ab-mo.map(s => "S" + str(s))),
  ([$z$ (Moore)], ab-mo.map(s => if s == 3 { 1 } else { 0 })),
)), [La sequenza $b a b a a b a$ ($x = 1$ è $b$): $a b a$ viene riconosciuta due volte])

Con Mealy $z$ sale appena $x$ diventa $a$ mentre si è in $S_2$, a metà ciclo, e scende al fronte successivo. Con Moore $z$ sale solo al fronte che porta in $S_3$, e resta 1 per tutto il ciclo, perché dipende solo dallo stato.
