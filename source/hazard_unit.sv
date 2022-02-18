// interface include
`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"
`include "datapath_types_pkg.vh"

module hazard_unit (
  hazard_unit_if.hu huif
);

import cpu_types_pkg::*;
import datapath_types_pkg::*;

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
    if (b_instr && (
        (huif.pred_taken && !taken) || 
        (!huif.pred_taken && taken))) begin
        huif.flush = 1'b1;
        huif.br_pred_result = WRONG_PRED;
    end
    else if (b_instr)
        huif.br_pred_result = RIGHT_PRED;
    else if (j_instr)
        huif.flush = 1'b1;
end

// LW DATA HAZARD
assign huif.insert_nop = huif.exec_MemRd & (huif.exec_wsel == huif.rs | huif.exec_wsel == huif.rt) & ~(huif.exec_wsel == 0);
// Mem Stage: instr = msif.insert_nop ? '0 : msif.in.instr;

endmodule
