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

#let mono(s) = text(font: "DejaVu Sans Mono", s)
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

#align(center)[
  #v(4cm)
  #text(24pt, weight: "bold")[Architettura degli elaboratori \ e sistemi operativi]
  #v(0.3cm)
  #text(14pt)[Diego Stefanini — prof. Marco Danelutto, a.a. 2026-27]
]
#v(1cm)
#outline()

= Fondamenti dei sistemi di elaborazione

== Memoria, processore, istruzioni

=== Il modello

Un calcolatore sono due pezzi: la *memoria* M e il *processore* P, che si parlano.

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

=== Il ciclo del processore

Il processore ripete per sempre questi quattro passi:

```c
while (true) {
    preleva l'istruzione da M[PC]
    decodifica      // che istruzione è?
    esegue
    scrive i risultati
}
```

=== Tipi di istruzione

Quali istruzioni esistono dipende dal processore (x86, ARM, RISC-V), ma i tipi sono sempre tre:

#table(
  columns: (auto, auto, 1fr),
  [Tipo], [Istruzioni], [Esempio],
  [operative], [`ADD SUB MUL DIV` \ `AND OR NOT` \ `SHIFT ROT` (sx/dx)], [`ADD R0, R1, R2` #h(0.5em) → #h(0.5em) REG[0] = REG[1] + REG[2]],
  [memoria], [`LOAD STORE`], [`LOAD R5, addr` #h(0.5em) → #h(0.5em) REG[5] = M[addr] \ `STORE` fa il contrario: registro → memoria],
  [salto], [salto], [cambia il PC: la prossima istruzione non è quella dopo],
)

#grid(columns: (1fr, 1fr), gutter: 1em, align: horizon,
```
inizio:  ADD R0, R0, R0   ← PC
         ADD R1, R1, R1
         SUB R2, R0, R1
         salto inizio     ─┐
            ↑──────────────┘
```,
[Il PC scende di un'istruzione alla volta; il *salto* lo rimette su `inizio`, quindi il programma ricomincia.])

=== Clock e legge di Moore

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
  - Transistor: nel 68000 20-40 µm, oggi 2 nm _(1000 nm = 1 µm)_.
  - Transistor più piccoli → nello spazio di un processore ne stanno più di uno (*multicore*):
  #align(center, stack(dir: ltr, spacing: 1em,
    box(stroke: 0.8pt, inset: 12pt)[P],
    align(horizon)[→],
    box(stroke: 0.8pt, inset: 4pt, grid(columns: 2, gutter: 4pt,
      ..range(4).map(_ => box(stroke: 0.6pt, inset: 6pt, radius: 50%)[P]))),
  ))
])

#base[legge di Moore][Il numero di transistor che si riescono a mettere su un chip raddoppia circa ogni due anni. È per questo che si passa dai µm ai nm e da un processore a più processori sullo stesso chip.]

== Astrazione

=== Livelli di astrazione

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

=== Interfacce

#grid(columns: (auto, 1fr), gutter: 1.5em, align: horizon,
stack(
  pila(([*Applicazione* — livello i+1], white), larghezza: 6cm),
  pila(([interfaccia: chiamate al sistema operativo], rgb("#fde2e2")), larghezza: 6cm),
  pila(([*Sistema operativo* — livello i], rgb("#eef4ff")), larghezza: 6cm),
  pila(([interfaccia: istruzioni in linguaggio macchina], rgb("#fde2e2")), larghezza: 6cm),
  pila(([*Architettura* — livello i−1], rgb("#eef4ff")), larghezza: 6cm),
),
[Fra due livelli c'è un'*interfaccia*: l'insieme delle funzionalità che il livello i−1 mette a disposizione del livello i.

Il livello i usa solo l'interfaccia, non sa com'è fatto sotto.])

*Conseguenza*: un programma gira solo dove trova l'interfaccia per cui è stato scritto.

#let x-rosso = text(fill: red, weight: "bold", size: 14pt)[✗]
#let v-verde = text(fill: verde, weight: "bold", size: 14pt)[✓]
#align(center, grid(columns: 3, gutter: 1.2em, align: center + bottom,
  [#pila(([App Android], white), ([Android], rgb("#eef4ff")), ([ARM], luma(230)), larghezza: 2.8cm)
   #x-rosso #pila(([iOS], rgb("#eef4ff")), ([ARM], luma(230)), larghezza: 2.8cm)
   #text(8pt)[stessa architettura, \ SO diverso: non gira]],
  [#pila(([App Windows], white), ([*Wine*], rgb("#fff3c4")), ([Linux (POSIX)], rgb("#eef4ff")), ([x86], luma(230)), larghezza: 2.8cm)
   #v-verde \ #text(8pt)[Wine offre l'interfaccia \ di Windows sopra Linux]],
  [#pila(([App con istruzioni x86], white), ([*Rosetta*], rgb("#fff3c4")), ([macOS], rgb("#eef4ff")), ([ARM], luma(230)), larghezza: 2.8cm)
   #v-verde \ #text(8pt)[Rosetta traduce \ le istruzioni x86 in ARM]],
))

=== Gerarchia, modularità, regolarità

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
  7 somme *una dopo l'altra*: ognuna aspetta la precedente.
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
}), [Ad albero: le somme dello stesso livello sono indipendenti, quindi le stesse 7 somme stanno in 3 passi]),
)

#grid(columns: (auto, 1fr), gutter: 1.5em, align: horizon,
canvas(length: 0.8cm, {
  import draw: *
  line((0, 0), (3, 0), (2.4, -1), (0.6, -1), close: true, fill: rgb("#eef4ff"))
  content((0.8, -0.35), text(9pt)[0]); content((2.2, -0.35), text(9pt)[1])
  content((0.8, 1), [x]); line((0.8, 0.75), (0.8, 0.05), mark: (end: "stealth"))
  content((2.2, 1), [y]); line((2.2, 0.75), (2.2, 0.05), mark: (end: "stealth"))
  line((-0.8, -0.5), (0.25, -0.5), mark: (end: "stealth"))
  line((1.5, -1.05), (1.5, -1.7), mark: (end: "stealth"))
}),
[*MUX*: il segnale che entra di lato sceglie quale ingresso passa in uscita, x (se vale 0) o y (se vale 1).])

== Numeri binari

=== Sistemi di numerazione posizionali

I circuiti digitali lavorano in *binario*: ogni segnale vale 0 o 1.

In un sistema posizionale *conta l'ordine delle cifre*: la stessa cifra vale di più quanto più è a sinistra. Ogni posizione ha un peso.

#align(center, table(columns: 5, align: center,
  [], [], [], [], [],
  [decimale], [$10^3 = 1000$], [$10^2 = 100$], [$10^1 = 10$], [$10^0 = 1$],
  [binario], [$2^3 = 8$], [$2^2 = 4$], [$2^1 = 2$], [$2^0 = 1$],
))

Esempio: $13_10 != 31_10$ e $10_2 != 01_2$. Stesse cifre, ordine diverso, numero diverso.

==== Da decimale a binario

Divido per 2 finché arrivo a 1, poi leggo i resti *dal basso verso l'alto*.

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

=== Somma e prodotto in binario

Come in decimale, ma $1 + 1 = 10_2$: scrivo 0 e riporto 1.

#align(center, grid(columns: 3, gutter: 3em, align: bottom,
  [#conto(sopra: ("8421",), "1010", "0100", "1110") \ #text(9pt)[10 + 4 = 14]],
  [#conto(sopra: ("111 ",), "0111", "0001", "1000") \ #text(9pt)[7 + 1 = 8 (riporti in grigio)]],
))

Il prodotto si fa in colonna come in decimale. In binario ogni riga è molto semplice: la cifra del moltiplicatore è 0 o 1, quindi la riga è tutta zeri oppure il numero stesso. È un *AND* bit a bit.

#align(center, grid(columns: 2, gutter: 4em, align: bottom,
  [#conto(op: "×", "12", "34", " 48", "36·", "408") \ #text(9pt)[in decimale]],
  [#conto(op: "×", "1010", "0100", "0000", "0000·", "1010··", "0000···", "0101000") \ #text(9pt)[10 × 4 = 40 = 32 + 8]],
))

=== Numeri negativi: modulo e segno

Il primo bit è il *segno* (0 = +, 1 = −), gli altri sono il *valore assoluto*.

#align(center, table(columns: 5, align: center, inset: 8pt,
  table.cell(fill: rgb("#fde2e2"))[*1*], [1], [1], [0], [0],
  table.cell(stroke: none)[#text(8pt)[segno]], table.cell(colspan: 4, stroke: none)[#text(8pt)[valore assoluto = 12]],
))
#align(center)[$-12$ in modulo e segno]

Per sommare A e B bisogna prima guardare i segni:

#align(center, table(columns: 2,
  [Caso], [Risultato],
  [$S_A = S_B$], [segno $S_A$, valore $V_A + V_B$],
  [$S_A != S_B$ e $V_A > V_B$], [segno $S_A$, valore $V_A - V_B$],
  [altrimenti], [segno $S_B$, valore $V_B - V_A$],
))

Esempi: $+12 + 12 = +24$, #h(0.5em) $-12 + (-12) = -24$, #h(0.5em) $-12 + 7 = -5$ (segni diversi: faccio $12 - 7$ e tengo il segno del più grande).

#nota[Servono confronti e sottrazioni: il circuito che somma diventa complicato. Il complemento a 2 risolve questo problema.]

=== Complemento a 2

Per passare da $n$ a $-n$:

#align(center, stack(dir: ltr, spacing: 0.8em,
  box(stroke: 0.6pt, inset: 6pt)[$n$ in binario], align(horizon)[→],
  box(stroke: 0.6pt, inset: 6pt, fill: rgb("#eef4ff"))[nego tutti i bit], align(horizon)[→],
  box(stroke: 0.6pt, inset: 6pt, fill: rgb("#eef4ff"))[$+1$], align(horizon)[→],
  box(stroke: 0.6pt, inset: 6pt)[$-n$],
))

Vale anche al contrario: rifacendo "nego + 1" su $-n$ torno a $n$. Così, se un risultato comincia con 1 (è negativo), capisco quanto vale.

Il vantaggio: *la somma si fa come una somma normale*, senza guardare i segni.

==== Esempio: $-12 + 7$ (5 bit)

#align(center, grid(columns: 3, gutter: 2.5em, align: bottom,
  [#passi(("12", "01100"), ("nego", "10011"), ("+1", "10100")) \ #text(9pt)[−12]],
  [#conto("10100", "00111", "11011") \ #text(9pt)[−12 + 7]],
  [#passi(("somma", "11011"), ("nego", "00100"), ("+1", "00101")) \ #text(9pt)[inizia per 1, è negativo: \ vale −5 ✓]],
))

==== Esempio: $-5 + (-3)$ (6 bit)

#align(center, grid(columns: 4, gutter: 2em, align: bottom,
  [#passi(("5", "000101"), ("nego", "111010"), ("+1", "111011")) \ #text(9pt)[−5]],
  [#passi(("3", "000011"), ("nego", "111100"), ("+1", "111101")) \ #text(9pt)[−3]],
  [#conto(sopra: ("11111 ",), "111011", "111101", "111000") \ #text(9pt)[esce un riporto 1 \ oltre i 6 bit: si butta]],
  [#passi(("somma", "111000"), ("nego", "000111"), ("+1", "001000")) \ #text(9pt)[vale 8, quindi \ il risultato è −8 ✓]],
))
