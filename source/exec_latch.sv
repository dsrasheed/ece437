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
    begin
        elif.out <= '0;
	elif.track_out <= '0;
    end
    else if (elif.stall == 1'b0)
    begin        
	elif.out <= elif.in;
	elif.track_out <= elif.track_in;
    end
    else
    begin
	elif.out <= elif.out;
	elif.track_out <= elif.track_out;
    end
end

endmodule
