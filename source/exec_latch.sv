// interface include
`include "exec_latch_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module exec_latch (
  input CLK, nRST,
  exec_latch_if.el elif
);

import cpu_types_pkg::*;

always_ff @ (posedge CLK, negedge nRST)
begin
    if (nRST == 1'b0)
        elif.out <= '0;
    else if (elif.stall == 1'b0)
        elif.out <= elif.in;
    else
	elif.out <= elif.out;
end

endmodule
