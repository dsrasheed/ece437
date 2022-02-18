// interface include
`include "fetch_latch_if.vh"

// memory types
`include "datapath_types_pkg.vh"

module fetch_latch (
  input CLK, nRST,
  fetch_latch_if.fl flif
);

always_ff @ (posedge CLK, negedge nRST)
begin
    if (nRST == 1'b0) begin
        flif.out <= '0;
        flif.track_out <= '0;
    end
    else if (flif.stall == 1'b1) begin
        flif.out <= flif.out;
        flif.track_out <= flif.track_out;
    end
    else if (flif.flush <= 1'b1) begin
	    flif.out <= '0;
        flif.track_out <= '0;
    end
    else begin
        flif.out <= flif.in;
        flif.track_out <= flif.track_in;
    end
end

endmodule
