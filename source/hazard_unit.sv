// interface include

// memory types
`include "cpu_types_pkg.vh"

module hazard_unit (
  CLK, nRST,
  hazard_unit_if.hu huif
);

import cpu_types_pkg::*;

// CONTROL FLOW HAZARDS
logic taken, b_instr, j_instr;

assign taken = (huif.PCSrc == BREQ & huif.zero) |
                (huif.PCSrc == BRNE & !huif.zero);
assign b_instr = huif.PCSrc == BREQ | huif.PCSrc == BRNE;
assign j_instr = huif.PCSrc == JUMP | huif.PCSrc == JUMPR;

always_comb
begin
    huif.flush = 1'b0;
    huif.br_pred_result = NA;
    if (branch_i && (
        (huif.pred_taken && !huif.taken) || 
        (!huif.pred_taken && huif.taken)) begin
        huif.flush = 1'b1;
        huif.br_pred_result = WRONG_PRED:
    end
    else if (branch_i)
        huif.br_pred_result = RIGHT_PRED;
    else if (jump_i)
        huif.flush = 1'b1;
end

// LW DATA HAZARD
logic [REG_W-1:0] prev_wsel, nxt_prev_wsel;
logic nxt_prev_lw, prev_lw;

always_ff @ (posedge CLK, negedge nRST)
begin
    if (nRST == 1'b0) begin
        prev_wsel <= '0;
        prev_lw <= 0;
    end
    else begin
        prev_wsel <= nxt_prev_wsel;
        prev_lw <= nxt_prev_lw;
    end
end

always_comb
begin
    nxt_prev_wsel = '0;
    nxt_prev_lw = 1'b0;
    if (huif.MemRd) begin
        nxt_prev_wsel = huif.wsel;
        nxt_prev_lw = 1'b1;
    end
end

assign huif.insert_nop = prev_lw & (prev_wsel == huif.rs | prev_wsel == huif.rt);
// Mem Stage: instr = msif.insert_nop ? '0 : msif.in.instr;

endmodule
