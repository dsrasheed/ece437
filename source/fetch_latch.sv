// interface include
`include "fetch_latch_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module fetch_latch (
  input CLK, nRST,
  fetch_latch.fl flif
);

import cpu_types_pkg::*;

always_ff @ (posedge CLK, negedge nRST)
begin
    if (nRST == 1'b0)
        flif.out <= '0;
    else if (flif.stall == 1'b0)
        flif.out <= flif.in;
    else
        flif.out <= '0;
end

endmodule
