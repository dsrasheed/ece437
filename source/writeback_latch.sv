// interface include
`include "writeback_latch_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module writeback_latch (
  input CLK, nRST,
  writeback_latch.wbl wblif
);

import cpu_types_pkg::*;

always_ff @ (posedge CLK, negedge nRST)
begin
    if (nRST == 1'b0)
        wblif.out <= '0;
    else if (wblif.stall == 1'b0)
        wblif.out <= wblif.in;
    else
        wblif.out <= '0;
end

endmodule
