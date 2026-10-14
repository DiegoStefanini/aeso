// Test dell'esercizio 5 (non modificarlo).
module test;
  reg [1:0] x, y;
  wire [1:0] z;
  wire c;
  add2 s(c, z, x, y);
  reg [2:0] somma;               // x + y su 3 bit: riporto e risultato
  integer i, errori;
  initial begin
    $dumpfile("test.vcd");
    $dumpvars;
    errori = 0;
    for (i = 0; i < 16; i = i + 1) begin
      {x, y} = i;
      somma = x + y;
      #2;
      if ({c, z} !== somma) begin
        $display("SBAGLIATO: %0d + %0d  c=%b z=%b, doveva essere c=%b z=%b",
                 x, y, c, z, somma[2], somma[1:0]);
        errori = errori + 1;
      end
    end
    if (errori == 0) $display("TUTTO GIUSTO");
    $finish;
  end
endmodule
