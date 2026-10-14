# AESO — Architettura degli elaboratori e sistemi operativi

Workflow generale: `../CLAUDE.md`.

- Docente: Marco Danelutto (corso A), a.a. 2026-27. ISA: ARMv7 per tutto il corso.
- Team MS Teams `6uk5ntg` (registrazioni e materiale nel folder Shared). Ricevimento mer e gio 11-13. Avvisi dell'ultimo minuto: calvados.di.unipi.it/storage/marcod/avviso.html
- Esame: 3+3 prove intermedie (risposta multipla, micro esercizi, assembler). Con 2 prove almeno "quasi sufficiente" per semestre si è esonerati dallo scritto. Default: scritto + orale; l'orale chiede collegamenti fra argomenti e ragionamento su situazioni nuove.
- Prove intermedie del primo semestre: 20 ott 2026 (reti combinatorie e sequenziali), 17 nov (assembler), 15 dic (microarchitettura). Prova: form con circa 20 domande a risposta multipla in 30 minuti.

Dispensa: si scrive normalmente (la pausa dell'11 ott è annullata dal 12 ott). In più Diego usa un progetto tutor su claude.ai, con gli esercizi su carta di cui manda la foto; istruzioni in `tutor.md`. Nel progetto carica man mano i fogli nuovi, le trascrizioni e la dispensa aggiornata. Se Diego cambia come vuole il tutor, si aggiorna `tutor.md` e lui lo reincolla nel progetto.

Video delle lezioni: su Stream, cartella `General/Registrazioni/` del team, file `aeso-XX.mp4` con gli stessi numeri dei fogli del prof (dal 13 ott un file per giorno, `aeso-1718.mp4` → `#video("1718", …)`) (la trascrizione dice in quale file sta ogni minuto). Nella dispensa `#video("09", "24:21", "29:54")` mette nel margine un ▶ che apre il video a quel minuto e dice fin dove ascoltare: aggiungilo a ogni concetto importante delle lezioni nuove.

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
| 13 ott 2026 | `aeso-1718.pdf` (2 fogli); registrazione `aeso-1718.mp4` → `2026-10-13.txt`; in `OneDrive_1_10-14-2026/` il video extra `ABA_all.mp4` (pomeriggio, → `2026-10-13-aba.txt`) e `EsempioVerifica-2526-1.pdf` (prima prova 2025/26, risposte lunedì 19 ott); `reti_combinatorie_verilog.pdf` (riassunto, niente di nuovo) | — | domande della prova dell'anno scorso (non nella dispensa); Verilog per reti sequenziali: registro, parità strutturale, clock nel test, MUX a 4 coi MUX a 2, modello behavioural, Quartus; video ABA: riconoscitore di aba Mealy e Moore, strutturale e behavioural, test; esercizio lasciato: stanzino, abba, parità in Verilog. Il processore ARM del libro mostrato solo come anticipazione |

`AESO-01` è solo organizzazione: sta qui sopra, non nella dispensa.

Capitoli della dispensa: 1 «Fondamenti dei sistemi di elaborazione», 2 «Reti logiche» (porte, tempo di stabilizzazione, componenti, semplificare le formule, Verilog e alee, memoria, reti sequenziali, reti sequenziali coi componenti e in Verilog).

Fin dove si è arrivati: lezione del 13 ott (fine di `aeso-1718.pdf`) e video `ABA_all.mp4`. La dispensa è aggiornata fino a qui. Il ▶ del video ABA manca: non si sa dove sta su Stream. Prossima lezione (19 ott): soluzioni della prova d'esempio, forse esercizi di Verilog.
