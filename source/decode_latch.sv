// interface include
`include "decode_latch_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module decode_latch (
  input CLK, nRST,
  decode_latch_if.dl dlif
);

import cpu_types_pkg::*;

always_ff @ (posedge CLK, negedge nRST)
begin
    if (nRST == 1'b0)
        dlif.out <= '0;
    else if (dlif.stall == 1'b0)
        dlif.out <= dlif.in;
    else
	dlif.out <= dlif.out;
end

endmodule
