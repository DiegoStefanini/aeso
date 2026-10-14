// Test dell'esercizio 7 (non modificarlo).
// Prima parte: x = y = 1 e c cambia, l'uscita dovrebbe restare sempre 1.
// Seconda parte: controlla che mux_ok sia ancora un MUX su tutte le combinazioni.
module test;
  reg x, y, c;
  wire z_d, z_ok;
  mux_d  m1(z_d, x, y, c);
  mux_ok m2(z_ok, x, y, c);
  integer i, buchi_d, buchi_ok, errori;
  initial begin
    $dumpfile("test.vcd");
    $dumpvars;
    buchi_d = 0; buchi_ok = 0; errori = 0;
    x = 1; y = 1; c = 1;
    #5 c = 0;
    #5 c = 1;
    #5 c = 0;
    #5;
    $display("mux_d  (dispensa): z non vale 1 per %0d unità di tempo", buchi_d);
    $display("mux_ok (tuo):      z non vale 1 per %0d unità di tempo", buchi_ok);
    for (i = 0; i < 8; i = i + 1) begin
      {x, y, c} = i;
      #5;
      if (z_ok !== (c ? y : x)) begin
        $display("SBAGLIATO: x=%b y=%b c=%b  z=%b, doveva essere %b", x, y, c, z_ok, c ? y : x);
        errori = errori + 1;
      end
    end
    if (buchi_ok == 0 && errori == 0) $display("TUTTO GIUSTO");
    else if (buchi_ok > 0) $display("SBAGLIATO: c'è ancora l'alea");
    $finish;
  end
  always #1 if ($time > 3 && $time < 20) begin
    if (z_d  !== 1) buchi_d  = buchi_d + 1;
    if (z_ok !== 1) buchi_ok = buchi_ok + 1;
  end
endmodule
