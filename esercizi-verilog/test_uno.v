// Test degli esercizi 1, 2 e 3 (non modificarlo).
module test;
  reg a, b, c;
  wire z;
  uno u(z, a, b, c);
  integer i, errori, giusto;
  initial begin
    $dumpfile("test.vcd");
    $dumpvars;
    errori = 0;
    for (i = 0; i < 8; i = i + 1) begin
      {a, b, c} = i;
      #2;
      giusto = (a + b + c == 1);
      if (z !== giusto) begin
        $display("SBAGLIATO: a=%b b=%b c=%b  z=%b, doveva essere %0d", a, b, c, z, giusto);
        errori = errori + 1;
      end
    end
    if (errori == 0) $display("TUTTO GIUSTO");
    $finish;
  end
endmodule
