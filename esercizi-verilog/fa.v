// Full adder della dispensa (non modificarlo): serve all'esercizio 5.
primitive far(output z, input x, input y, input r);   // risultato
  table  0 0 0 : 0;  0 0 1 : 1;  0 1 0 : 1;  0 1 1 : 0;
         1 0 0 : 1;  1 0 1 : 0;  1 1 0 : 0;  1 1 1 : 1;  endtable
endprimitive

primitive fac(output c, input x, input y, input r);   // riporto
  table  0 0 0 : 0;  0 0 1 : 0;  0 1 0 : 0;  0 1 1 : 1;
         1 0 0 : 0;  1 0 1 : 1;  1 1 0 : 1;  1 1 1 : 1;  endtable
endprimitive

module fa(output c, output z, input x, input y, input r);
  far ris(z, x, y, r);
  fac car(c, x, y, r);
endmodule
