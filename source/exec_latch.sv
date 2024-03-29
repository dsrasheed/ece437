// interface include
`include "exec_latch_if.vh"


module exec_latch (
  input CLK, nRST,
  exec_latch_if.el elif
);

always_ff @ (posedge CLK, negedge nRST)
begin
    if (nRST == 1'b0)
    begin
        elif.out <= '0;
	    elif.track_out <= '0;
    end
    else if (elif.stall == 1'b1) begin        
        elif.out <= elif.out;
        elif.track_out <= elif.track_out;
    end
    else if (elif.flush == 1'b1) begin
        elif.out <= '0;
        elif.track_out <= '0;
    end
    else begin
        elif.out <= elif.in;
        elif.track_out <= elif.track_in;
    end
end

endmodule
