// interface include
`include "mem_latch_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module mem_latch (
  input CLK, nRST,
  mem_latch.ml mlif
);

import cpu_types_pkg::*;

always_ff @ (posedge CLK, negedge nRST)
begin
    if (nRST == 1'b0)
        mlif.out <= '0;
    else if (mlif.stall == 1'b0)
        mlif.out <= mlif.in;
    else
        mlif.out <= '0;
end

endmodule
