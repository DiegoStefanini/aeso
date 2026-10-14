// Test dell'esercizio 6 (non modificarlo).
module test;
  reg [3:0] x, y;
  wire [3:0] z;
  max #(4) m(z, x, y);
  integer i, errori;
  initial begin
    errori = 0;
    for (i = 0; i < 256; i = i + 1) begin
      {x, y} = i;
      #2;
      if (z !== (x > y ? x : y)) begin
        if (errori < 5) $display("SBAGLIATO: x=%0d y=%0d  z=%0d", x, y, z);
        errori = errori + 1;
      end
    end
    if (errori == 0) $display("TUTTO GIUSTO");
    else $display("%0d combinazioni sbagliate su 256", errori);
    $finish;
  end
endmodule
