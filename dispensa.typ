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

Il corso parte dal basso (circuiti digitali, logica) e risale fino al sistema operativo. FA e MUX sono due circuiti che vedremo più avanti: il *full adder* somma una cifra, il *multiplexer* sceglie fra due segnali.

Come si parlano due livelli vicini?

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

#grid(columns: (auto, 1fr), gutter: 1.5em, align: horizon,
mux,
[*MUX*: il segnale che entra di lato sceglie quale ingresso passa in uscita, x (se c vale 0) o y (se c vale 1).])

== Numeri binari

I circuiti digitali lavorano in *binario*: ogni segnale vale 0 o 1.

In un sistema posizionale *conta l'ordine delle cifre*: la stessa cifra vale di più quanto più è a sinistra. Ogni posizione ha un peso.

#align(center, table(columns: 5, align: center,
  [], [], [], [], [],
  [decimale], [$10^3 = 1000$], [$10^2 = 100$], [$10^1 = 10$], [$10^0 = 1$],
  [binario], [$2^3 = 8$], [$2^2 = 4$], [$2^1 = 2$], [$2^0 = 1$],
))

Esempio: $13_10 != 31_10$ e $10_2 != 01_2$. Stesse cifre, ordine diverso, numero diverso.

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

Il prodotto si fa in colonna come in decimale. In binario ogni riga è molto semplice: la cifra del moltiplicatore è 0 o 1, quindi la riga è tutta zeri oppure il numero stesso. Come in decimale, ogni riga si sposta di un posto a sinistra (il · segna il posto lasciato vuoto).

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

Per sommare A e B bisogna prima guardare i segni:

#align(center, table(columns: 2,
  [Caso], [Risultato],
  [$S_A = S_B$], [segno $S_A$, valore $V_A + V_B$],
  [$S_A != S_B$ e $V_A > V_B$], [segno $S_A$, valore $V_A - V_B$],
  [altrimenti], [segno $S_B$, valore $V_B - V_A$],
))

Esempi: $+12 + 12 = +24$, #h(0.5em) $-12 + (-12) = -24$, #h(0.5em) $-12 + 7 = -5$ (segni diversi: faccio $12 - 7$ e tengo il segno del più grande).

#nota[Servono confronti e sottrazioni: il circuito che somma diventa complicato. Il complemento a 2 risolve questo problema.]

Si usa quindi il *complemento a 2*: i positivi si scrivono come sempre, e per passare da $n$ a $-n$:

#align(center, stack(dir: ltr, spacing: 0.8em,
  box(stroke: 0.6pt, inset: 6pt)[$n$ in binario], align(horizon)[→],
  box(stroke: 0.6pt, inset: 6pt, fill: rgb("#eef4ff"))[nego tutti i bit], align(horizon)[→],
  box(stroke: 0.6pt, inset: 6pt, fill: rgb("#eef4ff"))[$+1$], align(horizon)[→],
  box(stroke: 0.6pt, inset: 6pt)[$-n$],
))

Vale anche al contrario: rifacendo "nego + 1" su $-n$ torno a $n$. Così, se un risultato comincia con 1 (è negativo), capisco quanto vale.

Il vantaggio: *la somma si fa come una somma normale*, senza guardare i segni. Perché funzioni si capisce più sotto, leggendo i pesi dei bit.

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

Quanti numeri ci stanno in $n$ bit? Ogni bit raddoppia le combinazioni: $2 dot 2 dot 2 dots.c = 2^n$. Con 8 bit sono $2^8 = 256$ combinazioni, e il bit in posizione $i$ pesa $2^i$.

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

Ecco perché il complemento a 2 funziona. Un numero in complemento a 2 si legge così: *il bit più a sinistra pesa $-2^(n-1)$*, gli altri pesano $+2^i$ come sempre.

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

Il complemento a 2 permette di fare anche la *sottrazione con lo stesso sommatore*: $a - b = a + (-b)$, e $-b$ = nego $b$ e sommo 1. Il $+1$ entra dal riporto in ingresso del bit più a destra, che per la somma normale vale 0.

#let sommatore(neg) = canvas(length: 0.8cm, {
  import draw: *
  rect((0, 0), (1.4, 1), fill: rgb("#eef4ff")); content((0.7, 0.5), [*+*])
  content((0.35, 2.3), [a]); line((0.35, 2), (0.35, 1.05), mark: (end: "stealth"))
  content((1.05, 2.3), [b]); line((1.05, 2), (1.05, 1.05), mark: (end: "stealth"))
  if neg {
    rect((0.75, 1.3), (1.35, 1.7), fill: rgb("#fde2e2")); content((1.05, 1.5), text(7pt)[NOT])
  }
  line((2.4, 0.5), (1.45, 0.5), mark: (end: "stealth")); content((2.7, 0.5), if neg { text(fill: red)[*1*] } else [0])
  line((0.7, -0.05), (0.7, -0.8), mark: (end: "stealth")); content((0.7, -1.1), if neg [$a - b$] else [$a + b$])
  line((-0.05, 0.5), (-0.6, 0.5), mark: (end: "stealth")); content((-0.9, 0.5), text(8pt)[rip.])
})
#align(center, grid(columns: 2, gutter: 4em, align: bottom,
  figura(sommatore(false), [Somma: riporto in ingresso 0]),
  figura(sommatore(true), [Sottrazione: NOT su b, riporto in ingresso 1]),
))

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

Per i *numeri con la virgola* la notazione posizionale continua a destra della virgola con pesi negativi:

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
- i caratteri speciali: `CR` (a capo), `LF` (nuova riga), `TAB`, `DEL`, ...

#align(center, table(columns: 6, align: center,
  [carattere], [A], [B], [a], [c], [m],
  [codice], [65], [66], [97], [99], [109],
))

Le lettere hanno codici in ordine alfabetico, quindi confrontare due stringhe (in C `char *s1, *s2`) vuol dire confrontare i codici carattere per carattere: `"ciao" < "mondo"` perché `c` = 99 < `m` = 109.

= Reti logiche

== Porte logiche e tabelle di verità

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

Una funzione logica si può descrivere in tre modi, e da uno si passa all'altro:

#align(center, stack(dir: ltr, spacing: 0.8em,
  box(stroke: 0.6pt, inset: 8pt)[descrizione \ a parole], align(horizon)[→],
  box(stroke: 0.6pt, inset: 8pt, fill: rgb("#eef4ff"))[tabella \ di verità], align(horizon)[→],
  box(stroke: 0.6pt, inset: 8pt)[formula: *somma di prodotti* \ #text(8pt)[OR di tanti AND]], align(horizon)[→],
  box(stroke: 0.6pt, inset: 8pt, fill: rgb("#fff3c4"))[rete di porte \ (circuito)],
))

Esempio: il *MUX*. A parole: _scegli fra due ingressi $x$ e $y$ a seconda di un ingresso di controllo $c$_.

```c
if (c == 0) z = x;
else        z = y;
```

Dalla descrizione si ricava la tabella di verità. Poi, per ogni riga dove $z = 1$, scrivo un prodotto (AND) che vale 1 *solo* in quella riga: la variabile così com'è se vale 1, negata ($overline(x)$) se vale 0.

#let minterm(b) = {
  let v = ($x$, $y$, $c$)
  range(3).map(i => if b.at(i) == 1 { v.at(i) } else { $overline(#v.at(i))$ }).join()
}
#let muxf(b) = if b.at(2) == 0 { b.at(0) } else { b.at(1) }
#align(center, grid(columns: 2, gutter: 3em, align: horizon,
  tvb(($x$, $y$, $c$), ($z$, muxf), ([prodotto], b => if muxf(b) == 1 { text(fill: blu, minterm(b)) } else [])),
  align(left)[
    Le righe con $z = 1$ sono unite da un OR. Funziona perché ogni prodotto vale 1 solo nella sua riga, e l'OR vale 1 appena uno dei prodotti vale 1: la formula vale 1 esattamente nelle righe scelte.
    $ z = overline(x) y c + x overline(y) overline(c) + x y overline(c) + x y c $
    Per esempio $overline(x) y c$ = NOT($x$) AND $y$ AND $c$: vale 1 solo per $x = 0, y = 1, c = 1$.
  ],
))

Ogni prodotto diventa una porta AND a tre ingressi (il pallino sull'ingresso è un NOT), e le quattro uscite entrano in una OR:

#align(center, grid(columns: 2, gutter: 3em, align: horizon,
figura(canvas(length: 0.8cm, {
  import draw: *
  let colonne = (0, 0.7, 1.4) // linee x, y, c
  for (k, n) in ("x", "y", "c").enumerate() {
    content((colonne.at(k), 0.5), [$#n$]); line((colonne.at(k), 0.2), (colonne.at(k), -5.4))
  }
  let porte = ((0, 1, 1), (1, 0, 0), (1, 1, 0), (1, 1, 1))
  let or-y = (-2.35, -2.55, -2.75, -2.95)
  for (j, bits) in porte.enumerate() {
    let yy = -0.9 - j * 1.3
    porta-and((3, yy))
    for i in range(3) {
      let yi = yy + 0.3 - i * 0.3
      circle((colonne.at(i), yi), radius: 0.06, fill: black)
      if bits.at(i) == 0 {
        line((colonne.at(i), yi), (2.84, yi)); circle((2.92, yi), radius: 0.08)
      } else { line((colonne.at(i), yi), (3, yi)) }
    }
    line((3.9, yy), (4.5, yy), (4.5, or-y.at(j)), (5.3, or-y.at(j)))
  }
  porta-or((5.2, -2.65), h: 1.2)
  line((6.5, -2.65), (7.3, -2.65)); content((7.6, -2.65), [$z$])
}), [Il MUX come rete di porte]),
[... che si disegna col simbolo \ #mux],
))
