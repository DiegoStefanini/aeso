# AESO — Architettura degli elaboratori e sistemi operativi

Workflow generale: `../CLAUDE.md`.

- Docente: Marco Danelutto (corso A), a.a. 2026-27. ISA: ARMv7 per tutto il corso.
- Team MS Teams `6uk5ntg` (registrazioni e materiale nel folder Shared). Ricevimento mer e gio 11-13. Avvisi dell'ultimo minuto: calvados.di.unipi.it/storage/marcod/avviso.html
- Esame: 3+3 prove intermedie (risposta multipla, micro esercizi, assembler). Con 2 prove almeno "quasi sufficiente" per semestre si è esonerati dallo scritto. Default: scritto + orale; l'orale chiede collegamenti fra argomenti e ragionamento su situazioni nuove.
- Prove intermedie del primo semestre: 20 ott 2026 (reti combinatorie e sequenziali), 17 nov (assembler), 15 dic (microarchitettura).

## Mappa materiale ↔ lezione

Ogni numero del file del prof = **un'ora** di lezione. Diego ha sempre due ore di fila, quindi un giorno = due numeri.

| Giorno | File del prof (`slide/`) | Grezzo | Argomento |
|---|---|---|---|
| 16 set 2026 | `AESO-01.pdf` (slide organizzative), `AESO-02.pdf` (foglio a mano) | — | presentazione corso; memoria, processore, ciclo fetch-decode-execute, tipi di istruzione, clock |
| 21 set 2026 | `aeso-0304.pdf` (5 fogli a mano) | `grezzi/2026-09-21.md` | livelli di astrazione, interfacce, gerarchia/modularità/regolarità, binario, modulo e segno, complemento a 2 |
| 22 set 2026 | `aeso-0506.pdf` (6 fogli a mano) | `grezzi/22-09.md` (vuoto) | intervalli con n bit, overflow, sottrazione col sommatore, basi 8/16, floating point, ASCII; porte AND/OR/NOT, tabelle di verità, somma di prodotti, MUX come rete di porte |
| 28 set 2026 | `aeso0708.pdf` (5 fogli a mano); registrazione in `slide/registrazioni/2026-09-28.txt` | — | tempo di stabilizzazione (Δt, porte da 8, alberi), MUX a 4 da zero e componendo, full adder, sommatore a n bit, demultiplexer, sommatore/sottrattore e cammino critico |
| 29 set 2026 | `aeso-0910a.pdf` (5 fogli, le pagine 5-7 sono uguali), `aeso-0910b.pdf` (3 fogli); registrazione `2026-09-29.txt` | — | stima del ritardo del sommatore da zero, comparatore, codificatore, NAND e De Morgan, approccio strutturale, semplificazione algebrica, mappe di Karnaugh |

`AESO-01` è solo organizzazione: sta qui sopra, non nella dispensa.

Fin dove si è arrivati: mappe di Karnaugh (fine di `aeso-0910b.pdf`), reti combinatorie chiuse. La prossima lezione comincia gli automi (reti sequenziali): capitolo nuovo o nuove sezioni del capitolo 2 "Reti logiche".
