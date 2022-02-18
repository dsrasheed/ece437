// interface include
`include "decode_latch_if.vh"

module decode_latch (
  input CLK, nRST,
  decode_latch_if.dl dlif
);

always_ff @ (posedge CLK, negedge nRST)
begin
    if (nRST == 1'b0) begin
        dlif.out <= '0;
	    dlif.track_out <= '0;
    end
    else if (dlif.stall == 1'b1) begin
        dlif.out <= dlif.out;
	    dlif.track_out <= dlif.track_out;
    end
    else if (dlif.flush == 1'b1) begin
        dlif.out <= '0;
        dlif.track_out <= '0;
    end
    else begin
        dlif.out <= dlif.in;
        dlif.track_out <= dlif.track_in;
    end
end

endmodule
