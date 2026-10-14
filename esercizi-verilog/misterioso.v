// Esercizio 4: non modificare questo file.
module misterioso(output z, input a, input b);
  assign z = !(a || b) || (a && b);
endmodule
