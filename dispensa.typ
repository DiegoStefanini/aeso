#import "@preview/cetz:0.4.2": canvas, draw

#set document(title: "AESO — Dispensa")
#set page(paper: "a4", margin: 2.2cm, numbering: "1")
#set text(lang: "it", size: 11pt)
#set par(justify: true)
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => { pagebreak(weak: true); it }
#show raw.where(block: true): block.with(fill: luma(245), inset: 8pt, radius: 4pt, width: 100%)
#show raw.where(block: false): box.with(fill: luma(240), inset: (x: 3pt), outset: (y: 3pt), radius: 2pt)
#set table(stroke: 0.5pt + luma(180), inset: 6pt)
#show table.cell.where(y: 0): strong

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
  line((1.5, -1.05), (1.5, -1.7), mark: (end: "stealth"))
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

#align(center)[
  #v(4cm)
  #text(24pt, weight: "bold")[Architettura degli elaboratori \ e sistemi operativi]
  #v(0.3cm)
  #text(14pt)[Diego Stefanini — prof. Marco Danelutto, a.a. 2026-27]
]
#v(1cm)
#outline(depth: 2)

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
  - Transistor più piccoli → nello spazio di un processore ne stanno più di uno. Ogni processore sul chip si chiama *core*, il chip è *multicore*:
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
}), [Regolarità: 123 + 789 = 912 con tre FA uguali in cascata. \ Ogni FA somma una cifra e passa il riporto a sinistra]),
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
  table(columns: 8, align: center, inset: 5pt,
    ..range(8).rev().map(i => text(8pt)[$2^#i$]),
    ..range(8).map(_ => [ ]),
  ),
  table(columns: 2, align: (right, right), inset: 4pt,
    [binario], [valore],
    ..(0, 1, 2, 3, 4).map(v => (mono(c2(v, 8)), [#v])).flatten(),
    [⋮], [⋮],
    mono(c2(255, 8)), [255],
  ),
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
[... che si disegna col simbolo \ #mux],
))

Le tre porte si possono ottenere tutte da una sola, la *NAND*: un AND con l'uscita negata (il pallino in fondo).

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
#align(center, grid(columns: 3, gutter: 3em, align: center + bottom,
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
))

Con un solo tipo di porta si risparmia lavoro di progettazione, ma non spazio sul chip: per ogni AND o OR servono più NAND.

== Tempo di stabilizzazione

Una porta non risponde subito. Da quando gli ingressi hanno il loro valore (istante $t_0$) a quando l'uscita è quella giusta ($t_1$) passa del tempo, e nel frattempo l'uscita può valere qualunque cosa. È il *tempo di stabilizzazione* (o ritardo) della rete.

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
}), [Il MUX con $c = 1$ fa passare $y = 0$, ma $z$ è affidabile solo da $t_1$ in poi])

Il ritardo di una porta dipende da quanti ingressi ha: resta basso fino a una certa soglia, poi esplode. Nel corso si usa questa convenzione:

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

Una rete si può costruire in due modi: da zero con i cinque passi, oppure *componendo* reti già fatte. Esempio: un MUX che sceglie fra *quattro* ingressi con due bit di controllo $c_0 c_1$ (qui $c_0$ è quello più a sinistra). La barretta con un numero indica quanti bit passano su un filo.

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
#align(center, grid(columns: 2, gutter: 2em, align: horizon,
  figura(rete-sp(($c_0$, $c_1$, $x_0$, $x_1$, $x_2$, $x_3$), ((0, 0, 1, nc, nc, nc), (0, 1, nc, 1, nc, nc), (1, 0, nc, nc, 1, nc), (1, 1, nc, nc, nc, 1))),
    [Da zero: quattro AND e una OR, $2 Delta t$]),
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

*Componendo.* Scegliere fra quattro vuol dire scegliere prima dentro ogni coppia, poi fra le due coppie. Bastano tre MUX a due ingressi: il bit meno significativo $c_1$ sceglie dentro le coppie, il più significativo $c_0$ sceglie la coppia. Non serve la tabella, ma il segnale attraversa due MUX di fila: $2 Delta t + 2 Delta t = 4 Delta t$. I due MUX in alto lavorano insieme, quindi contano una volta sola.

#nota[*Regola generale*: la rete progettata da zero ha un tempo di stabilizzazione minore o uguale a quella ottenuta componendo, perché è ottimizzata tutta insieme. Comporre però costa molta meno fatica.]

== Componenti

Alcune reti si usano così spesso che diventano mattoni pronti, come il MUX.

Il *full adder* (FA) fa una colonna della somma in binario: prende i due bit $x$ e $y$ e il riporto $r$ che arriva dalla colonna a destra, e calcola il bit del risultato e il riporto per la colonna a sinistra.

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

Ogni formula ha quattro termini di tre variabili, tutto sotto 8: un livello di AND e uno di OR, quindi il FA si stabilizza in $2 Delta t$.

Per sommare numeri di $n$ bit si mettono $n$ FA *in cascata*: il riporto di ognuno entra nel successivo. Da qui in poi i bit si numerano col loro peso: $x_0$ è il meno significativo, $x_(n-1)$ il più significativo.

#figura(catena-fa(($n-1$, none, $1$, $0$)), [Sommatore a $n$ bit: ogni FA aspetta il riporto di quello alla sua destra])

Ogni FA deve aspettare il riporto del precedente, quindi i ritardi *si sommano*: $n dot 2 Delta t = 2 n Delta t$. Con 2 bit sono $4 Delta t$. Se l'ultimo riporto vale 1, la somma di due numeri senza segno non sta in $n$ bit.

Lo stesso sommatore fa anche la sottrazione: $x - y = x + overline(y) + 1$. Un MUX sceglie fra $y$ e $overline(y)$, e lo stesso bit di controllo entra come riporto iniziale.

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

E progettando il sommatore da zero? La tabella non si scrive, ma il tempo si può stimare. Per due numeri di $n$ bit:

- gli ingressi sono $2 n$, quindi le righe sono $2^(2 n)$;
- una colonna d'uscita ha al massimo $2^(2 n) - 1$ uni (con tutti 1 sarebbe la costante 1), quindi l'OR ha circa $2^(2 n)$ ingressi: servono $ceil(log_8 2^(2 n)) = ceil((2 n) / 3)$ livelli, perché $log_8 a = (log_2 a) / (log_2 8)$;
- ogni AND ha $2 n$ ingressi: $ceil(log_8 2 n)$ livelli.

Con 2 bit, contando anche il riporto iniziale, gli ingressi sono 5 e le righe 32: un OR di al massimo 31 termini (2 livelli) e AND da 5 ingressi (1 livello), cioè $3 Delta t$ contro i $4 Delta t$ dei due FA in cascata. Con $n = 8$: $ceil(16 / 3) + ceil(log_8 16) = 6 + 2 = 8 Delta t$, contro i $16 Delta t$ degli otto FA in cascata. Ma la tabella avrebbe $2^16 = 65536$ righe: nessuno la scrive, si usano i FA.

#nota[Se in una colonna gli 1 sono più della metà, conviene scrivere i termini per gli *0* e negare l'uscita, tanto il NOT non costa: i termini sono al massimo la metà delle righe.]

Il *demultiplexer* è il contrario del MUX: un ingresso $x$ e più uscite. Il controllo sceglie su quale uscita mandare $x$; le altre valgono 0. Servirà per scegliere in quale cella di memoria scrivere.

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

Il *comparatore* dice se due numeri di $n$ bit sono uguali: uscita 1 se sono uguali, 0 altrimenti. Per un bit la formula è $z = overline(x) thin overline(y) + x y$, che non si semplifica: $2 Delta t$. È il negato dello *XOR* (OR esclusivo), che vale 1 quando i due bit sono diversi. Per $n$ bit si confronta ogni coppia $x_i, y_i$ e si fa l'AND di tutte le risposte: basta una coppia diversa per dare 0. Avendo una porta già pronta per il confronto di un bit, con ritardo $Delta t$, si guadagnerebbe solo $1 Delta t$: il livello dell'AND finale resta.

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

Il *codificatore* ha $n$ ingressi di cui *esattamente uno* vale 1, e $log_2 n$ uscite che dicono in che posizione sta quell'1 (di solito $2^k$ ingressi e $k$ uscite). Le altre combinazioni di ingressi non sono ammesse, quindi non compaiono nella tabella.

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

Costruire una rete componendo mattoni pronti, come nel circuito che somma e sottrae, si chiama *approccio strutturale*. Si parte da uno pseudocodice fatto di funzioni e scelte, e ogni pezzo diventa un componente: ogni funzione è una rete, la condizione è una rete con un bit d'uscita, e l'`if` è un MUX comandato da quel bit.

#align(center, grid(columns: 2, gutter: 4em, align: center + bottom,
  [#se-allora([cond], [F], [G]) \ `if (cond) f(x) else g(x)`],
  [#se-allora([pari], [`x++`], [`x--`]) \ `if (pari(x)) x++ else x--`],
))

Nell'esempio di destra, con $x$ di $n$ bit, i tre blocchi si fanno con quello che c'è già:

- `x++`: un sommatore con ingressi $x$ e la costante 1, riporto iniziale 0. Una costante è un filo fisso a 0 o a 1;
- `x--`: un sommatore con $x$ e la costante 1 negata, riporto iniziale 1: è $x - 1$ fatto come sottrazione;
- `pari(x)`: un numero è pari quando il suo ultimo bit $x_0$ vale 0, quindi basta un NOT su $x_0$, senza calcoli.

== Semplificare le formule

Fra la somma di prodotti e la rete si può *semplificare* la formula con le regole dell'algebra. Si raccoglie, poi si usano $t + overline(t) = 1$ e $x dot 1 = x$:

$ z = x y t + x y overline(t) = x y (t + overline(t)) = x y $

Qui l'OR sparisce: da $2 Delta t$ a $1 Delta t$. Un termine si può anche usare due volte, perché $x + x = x$:

$ z = x y t + x y overline(t) + overline(x) y t = underbrace(x y t + x y overline(t), x y) + underbrace(x y t + overline(x) y t, y t) = x y + y t $

I livelli restano due, quindi il tempo non cambia, ma le porte calano: da 3 AND e 1 OR a 2 AND e 1 OR. Con porte da soli 2 ingressi il guadagno è più grande, perché ogni AND da tre ingressi diventa due porte: da 8 porte a 3. Raccogliendo ancora, $z = y (x + t)$: 2 porte.

Semplificare quindi non sempre fa guadagnare tempo, ma fa risparmiare porte: meno spazio e meno consumo. Allo stesso modo il riporto del FA, usando tre volte il termine $x y r$, diventa:

$ "rip" = y r + x r + x y $

Per vedere cosa raccogliere si usano le *mappe di Karnaugh*: sono la tabella di verità ridisegnata come griglia, con alcune variabili sulle colonne e le altre sulle righe. Le combinazioni sono scritte nell'ordine 00, 01, 11, 10, così fra due celle vicine cambia *un solo bit*.

#let ka(c, r) = {
  let ((x, y), (a, b)) = (c, r)
  if (x == 0 and a == 0) or (a == 1 and b == 0) or (y == 0 and a == 0 and b == 1) { 1 } else { 0 }
}
#block(breakable: false, align(center, grid(columns: 3, gutter: 2.5em, align: center + bottom,
  [#kmap(($x$,), ($y$,), (c, r) => if c == r { 1 } else { 0 }) \ #text(9pt)[2 variabili: \ il comparatore a un bit]],
  [#kmap(($x$, $y$), ($a$, $b$), ka) \ #text(9pt)[4 variabili]],
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
