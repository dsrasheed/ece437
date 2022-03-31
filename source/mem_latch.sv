// interface include
`include "mem_latch_if.vh"


module mem_latch (
  input CLK, nRST,
  mem_latch_if.ml mlif
);

always_ff @ (posedge CLK, negedge nRST)
begin
    if (nRST == 1'b0) begin
        mlif.out <= '0;
	    mlif.track_out <= '0;
    end
    else if (mlif.stall == 1'b1) begin
        mlif.out <= mlif.out;
	    mlif.track_out <= mlif.track_out;
    end
    else begin
        mlif.out <= mlif.in;
        mlif.track_out <= mlif.track_in;
    end
end

endmodule
