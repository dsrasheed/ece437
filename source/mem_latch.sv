// interface include
`include "mem_latch_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module mem_latch (
  input CLK, nRST,
  mem_latch_if.ml mlif
);

import cpu_types_pkg::*;

always_ff @ (posedge CLK, negedge nRST)
begin
    if (nRST == 1'b0)
    begin
        mlif.out <= '0;
	mlif.track_out <= '0;
    end
    else if (mlif.stall == 1'b0)
    begin
        mlif.out <= mlif.in;
	mlif.track_out <= mlif.track_in;
    end
    else
    begin
	mlif.out <= mlif.out;
	mlif.track_out <= mlif.track_out;
    end
end

endmodule
