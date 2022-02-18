// interface include
`include "decode_stage_if.vh"
`include "control_unit_if.vh"
//`include "control_unit.sv"
`include "register_file_if.vh"
//`include "register_file.sv"

// memory types
`include "cpu_types_pkg.vh"

module decode_stage (
  input CLK, nRST,
  decode_stage_if.ds dsif
);

import cpu_types_pkg::*;

control_unit_if cuif ();
register_file_if rfif ();

control_unit ctrl_unit(cuif.cu);
register_file reg_file(CLK, nRST, rfif.rf);

// GLUE WIRES
r_t rinstr;
i_t iinstr;
j_t jinstr;
word_t extOut;

//Track
assign dsif.track_out.pc = dsif.track_in.pc;
assign dsif.track_out.instr = dsif.in.instr;
assign dsif.track_out.opcode = rinstr.opcode;
assign dsif.track_out.funct = rinstr.funct;
assign dsif.track_out.rs = rinstr.rs;
assign dsif.track_out.rt = rinstr.rt;
assign dsif.track_out.wsel = cuif.WrLinkReg == 1 ? 31 : cuif.RegDst == 1 ? rinstr.rd : rinstr.rt;
assign dsif.track_out.RegWr = cuif.RegWr;
assign dsif.track_out.WrLinkReg = cuif.WrLinkReg;
assign dsif.track_out.lui = iinstr.imm;
assign dsif.track_out.shamt = rinstr.shamt;
assign dsif.track_out.imm = extOut;
assign dsif.track_out.branch = (iinstr.imm[15]) ? {16'hffff, iinstr.imm} : {16'h0000, iinstr.imm};
assign dsif.track_out.daddr = dsif.track_in.daddr;
assign dsif.track_out.dstore = dsif.track_in.dstore;
assign dsif.track_out.nxt_pc = dsif.track_in.nxt_pc;
assign dsif.track_out.writeback = dsif.track_in.writeback;

// INSTRUCTION ASSIGNMENTS FOR CONVENIENCE
always_comb begin
    rinstr = dsif.in.instr;
    iinstr = dsif.in.instr;
    jinstr = dsif.in.instr;
end

// EXTENDER AND UPPER SHIFT
always_comb begin
    extOut = {'0, iinstr.imm};
    if (cuif.ExtOp == 1 && iinstr.imm[IMM_W-1] == 1)
        extOut = {16'hffff, iinstr.imm};
    else if (cuif.ShiftUp == 1)
        extOut = {iinstr.imm[IMM_W-1:0], 16'h0};
end

// Control Unit Input Assignments
assign cuif.opcode = rinstr.opcode;
assign cuif.funct = rinstr.funct;

// Register File Input Assignments
assign rfif.rsel1 = rinstr.rs;
assign rfif.rsel2 = rinstr.rt;
assign rfif.wdat = dsif.wdat;
assign rfif.WEN = dsif.RegWr;
//assign rfif.WEN = dsif.stall == 1'b1 ? 0 : dsif.RegWr;
assign rfif.wsel = dsif.wsel;

// Output to Prediction Unit
assign dsif.PCSrc = cuif.PCSrc;

// Outputs to Decode Latch
assign dsif.out.halt = cuif.halt;
assign dsif.out.wsel = cuif.WrLinkReg == 1 ? 31 : cuif.RegDst == 1 ? rinstr.rd : rinstr.rt;
assign dsif.out.RegWr = cuif.RegWr;
assign dsif.out.MemToReg = cuif.MemToReg;
assign dsif.out.WrLinkReg = cuif.WrLinkReg;
assign dsif.out.MemRd = cuif.MemRd;
assign dsif.out.MemWr = cuif.MemWr;
assign dsif.out.PCSrc = cuif.PCSrc;
assign dsif.out.ALUOp = cuif.ALUOp;
assign dsif.out.ALUSrc = cuif.ALUSrc;
assign dsif.out.extOut = extOut;
assign dsif.out.rdat1 = rfif.rdat1;
assign dsif.out.rdat2 = rfif.rdat2;
assign dsif.out.j_offset = jinstr.addr;
assign dsif.out.pc = dsif.in.pc;
assign dsif.out.rs = rinstr.rs;
assign dsif.out.rt = rinstr.rt;
assign dsif.out.pred_taken = dsif.pred_taken;

endmodule
