// memory types
`include "cpu_types_pkg.vh"
`include "request_unit_if.vh"

import cpu_types_pkg::*;

module request_unit (
  input logic CLK, nRST,
  request_unit_if.ru ruif
);

always_ff @ (posedge CLK, negedge nRST)
begin
    if (nRST == 1'b0) begin
        ruif.drreq <= 1'b0;
        ruif.dwreq <= 1'b0;
        ruif.ireq <= 1'b1;
    end
    else begin
        if (ruif.iready && ruif.dREN && !ruif.drreq)
            ruif.drreq <= 1'b1;
        else if (ruif.dREN && ruif.dready)
            ruif.drreq <= 1'b0;
        else
            ruif.drreq <= ruif.drreq;
        
        if (ruif.iready && ruif.dWEN && !ruif.dwreq)
            ruif.dwreq <= 1'b1;
        else if (ruif.dWEN && ruif.dready)
            ruif.dwreq <= 1'b0;
        else
            ruif.dwreq <= ruif.dwreq;
    end
end

assign ruif.stall = (~ruif.iready & ~ruif.dready) | ((ruif.dREN | ruif.dWEN) & ~ruif.dready);

endmodule