// Esercizio 6: il massimo fra due numeri senza segno da N bit.
// z = il più grande fra x e y. Usa l'espressione cond ? a : b.
// In Verilog x > y confronta due numeri come in C.
// N vale 32 se non si dice niente; il test ne crea una copia con N = 4: max #(4) m(z, x, y);

module max #(parameter N = 32) (output [N-1:0] z, input [N-1:0] x, input [N-1:0] y);
  // scrivi qui
endmodule
