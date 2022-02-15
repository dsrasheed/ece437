// interface include
`include "fetch_latch_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module fetch_latch (
  input CLK, nRST,
  fetch_latch_if.fl flif
);

import cpu_types_pkg::*;

always_ff @ (posedge CLK, negedge nRST)
begin
    if (nRST == 1'b0)
    begin
        flif.out <= '0;
        flif.track_out <= '0;
    end
    else if (flif.stall == 1'b0)
    begin
        flif.out <= flif.in;
        flif.track_out <= flif.track_in;
    end
    else
    begin
	flif.out <= '0;
        flif.track_out <= '0;
    end
end

endmodule
