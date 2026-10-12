# AESO — Architettura degli elaboratori e sistemi operativi

Workflow generale: `../CLAUDE.md`.

- Docente: Marco Danelutto (corso A), a.a. 2026-27. ISA: ARMv7 per tutto il corso.
- Team MS Teams `6uk5ntg` (registrazioni e materiale nel folder Shared). Ricevimento mer e gio 11-13. Avvisi dell'ultimo minuto: calvados.di.unipi.it/storage/marcod/avviso.html
- Esame: 3+3 prove intermedie (risposta multipla, micro esercizi, assembler). Con 2 prove almeno "quasi sufficiente" per semestre si è esonerati dallo scritto. Default: scritto + orale; l'orale chiede collegamenti fra argomenti e ragionamento su situazioni nuove.
- Prove intermedie del primo semestre: 20 ott 2026 (reti combinatorie e sequenziali), 17 nov (assembler), 15 dic (microarchitettura).

Dispensa: si scrive normalmente (la pausa dell'11 ott è annullata dal 12 ott). In più Diego usa un progetto tutor su claude.ai, con gli esercizi su carta di cui manda la foto; istruzioni in `tutor.md`. Nel progetto carica man mano i fogli nuovi, le trascrizioni e la dispensa aggiornata. Se Diego cambia come vuole il tutor, si aggiorna `tutor.md` e lui lo reincolla nel progetto.

Libro di testo: Harris & Harris, *Sistemi digitali e architettura dei calcolatori*, in `slide/libro-harris.pdf` (pagina del libro + 9 = pagina del PDF). Il prof spiega molto da lì: per ogni lezione leggi anche il paragrafo corrispondente e usalo per spiegare meglio (termini, figure), senza aggiungere argomenti non fatti in aula. Cap. 2 reti combinatorie, cap. 3 latch/flip-flop/macchine a stati, cap. 4 HDL (ma il prof usa Verilog 2003, non il SystemVerilog del libro: per la sintassi vale `slide/Verilog.pdf`).

## Mappa materiale ↔ lezione

Ogni numero del file del prof = **un'ora** di lezione. Diego ha sempre due ore di fila, quindi un giorno = due numeri.

| Giorno | File del prof (`slide/`) | Grezzo | Argomento |
|---|---|---|---|
| 16 set 2026 | `AESO-01.pdf` (slide organizzative), `AESO-02.pdf` (foglio a mano) | — | presentazione corso; memoria, processore, ciclo fetch-decode-execute, tipi di istruzione, clock |
| 21 set 2026 | `aeso-0304.pdf` (5 fogli a mano) | `grezzi/2026-09-21.md` | livelli di astrazione, interfacce, gerarchia/modularità/regolarità, binario, modulo e segno, complemento a 2 |
| 22 set 2026 | `aeso-0506.pdf` (6 fogli a mano) | `grezzi/22-09.md` (vuoto) | intervalli con n bit, overflow, sottrazione col sommatore, basi 8/16, floating point, ASCII; porte AND/OR/NOT, tabelle di verità, somma di prodotti, MUX come rete di porte |
| 28 set 2026 | `aeso0708.pdf` (5 fogli a mano); registrazione in `slide/registrazioni/2026-09-28.txt` | — | tempo di stabilizzazione (Δt, porte da 8, alberi), MUX a 4 da zero e componendo, full adder, sommatore a n bit, demultiplexer, sommatore/sottrattore e cammino critico |
| 29 set 2026 | `aeso-0910a.pdf` (5 fogli, le pagine 5-7 sono uguali), `aeso-0910b.pdf` (3 fogli); registrazione `2026-09-29.txt` | — | stima del ritardo del sommatore da zero, comparatore, codificatore, NAND e De Morgan, approccio strutturale, semplificazione algebrica, mappe di Karnaugh |
| 5 ott 2026 | `aeso-1112.pdf` (4 fogli); registrazione `2026-10-05.txt`; `Verilog.pdf` (dispensa del prof), `StrumentiVerilog.pdf`, esempi in `slide/verilog/` | — | HDL e Verilog (primitive con tabella, module con assign, Icarus e gtkwave), FPGA; esercizi: x pari e divisibile per 4, moltiplicatore da 2 bit con Karnaugh |
| 6 ott 2026 | `aeso-1314.pdf` (5 fogli); registrazione `2026-10-06.txt` | — | memoria e reti sequenziali, latch SR, D-latch, clock, flip-flop e registro, SR in Verilog, automa di Moore per la parità di una sequenza di bit, procedura di progetto e ciclo di clock, schema di Mealy; esercizio lasciato: la parità con un automa di Mealy |
| 12 ott 2026 | `aeso-1516.pdf` (6 fogli; la registrazione si ferma prima dell'ultimo, Moore per abba); registrazione `2026-10-12.txt` | — | esercitazione: rete letta al contrario, display a 7 segmenti con Karnaugh e con registri + MUX (celle FPGA), alea del MUX in Verilog con `#1`; parità con Mealy, riconoscitore di abba (Mealy e Moore), stanzino con contatore, porte chiuse dopo k ingressi (Moore coi componenti) |

`AESO-01` è solo organizzazione: sta qui sopra, non nella dispensa.

Capitoli della dispensa: 1 «Fondamenti dei sistemi di elaborazione», 2 «Reti logiche» (porte, tempo di stabilizzazione, componenti, semplificare le formule, Verilog e alee, memoria, reti sequenziali, reti sequenziali coi componenti).

Fin dove si è arrivati: esercitazione del 12 ott fino al riconoscitore di abba con Moore (fine di `aeso-1516.pdf`). La dispensa è aggiornata fino a qui. Prossima lezione (13 ott): esercizi e domande dei compiti passati in vista della prova del 20 ott.
