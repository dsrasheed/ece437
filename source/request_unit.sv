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

/*module request_unit (
    input logic CLK, nRST,
    request_unit_if.ru ruif
);

typedef enum logic [2:0] {
    WAIT_INSTR,
    EXEC_INSTR,
    READ_DATA,
    STORE_DATA,
    WRITE_DATA
} rq_state;

rq_state state, nxt_state;

always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST == 1'b0)
        state <= WAIT_INSTR;
    else
        state <= nxt_state;
end

always_comb begin
    nxt_state = state;
    casez (state)
        WAIT_INSTR: if (ruif.iready) nxt_state = EXEC_INSTR;
        EXEC_INSTR: begin
            if (ruif.dREN) nxt_state = READ_DATA;
            else if (ruif.dWEN) nxt_state = WRITE_DATA;
            else nxt_state = WAIT_INSTR;
        end
        READ_DATA: if (ruif.dready) nxt_state = STORE_DATA;
        STORE_DATA: nxt_state = WAIT_INSTR;
        WRITE_DATA: if (ruif.dready) nxt_state = WAIT_INSTR;
    endcase
end

assign ruif.stall = state == WAIT_INSTR || 
                    state == READ_DATA  || 
                    state == WRITE_DATA ||
                    state == EXEC_INSTR && ruif.dREN;
assign ruif.drreq = state == READ_DATA || state == STORE_DATA;
assign ruif.dwreq = state == WRITE_DATA;
assign ruif.ireq = 1'b1;

endmodule*/