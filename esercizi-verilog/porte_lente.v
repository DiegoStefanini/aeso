// Porte che rispondono dopo 1 unità di tempo, e il MUX con l'alea (dalla dispensa).
// Non modificarlo: serve all'esercizio 7.
module and_d(output z, input x, input y);
  assign #1 z = x && y;
endmodule

module or_d(output z, input x, input y);
  assign #1 z = x || y;
endmodule

module not_d(output z, input x);
  assign #1 z = !x;
endmodule

module mux_d(output z, input x, input y, input c);
  wire w1, w2, w3;
  not_d n(w1, c);
  and_d a1(w2, x, w1);
  and_d a2(w3, y, c);
  or_d  o(z, w2, w3);
endmodule
