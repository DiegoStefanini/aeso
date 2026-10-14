# Esercizi di Verilog (sezione «Descrivere le reti in Verilog»)

Ogni esercizio è un file `esN.v` da completare. Il test è già scritto: compila e lancia, e se stampa `TUTTO GIUSTO` hai finito. Il comando per ogni esercizio:

| Esercizio | Cosa allena | Comando |
|---|---|---|
| 1 | `primitive` con la tabella | `iverilog es1.v test_uno.v && vvp a.out` |
| 2 | la stessa rete con `assign` | `iverilog es2.v test_uno.v && vvp a.out` |
| 3 | la stessa rete con le porte `and`/`or`/`not` e i `wire` | `iverilog es3.v test_uno.v && vvp a.out` |
| 4 | scrivere il modulo di test da soli | `iverilog misterioso.v es4.v && vvp a.out` |
| 5 | comporre moduli: sommatore a 2 bit con due `fa` | `iverilog fa.v es5.v test_add2.v && vvp a.out` |
| 6 | `parameter`, numeri da N bit, `? :` | `iverilog es6.v test_max.v && vvp a.out` |
| 7 | ritardi `#1` e alea del MUX | `iverilog porte_lente.v es7.v test_alea.v && vvp a.out` |

Per vedere le forme d'onda: `gtkwave test.vcd`.

Gli esercizi 1, 2 e 3 sono la stessa rete scritta in tre modi, come il MUX nella dispensa: lo stesso test le prova tutte e tre.
