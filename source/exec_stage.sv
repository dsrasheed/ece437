// interface include
`include "exec_stage_if.vh"
//`include "alu.sv"
`include "alu_if.vh"
//`include "nxt_pc_logic.sv"
`include "nxt_pc_logic_if.vh"

module exec_stage (
  exec_stage_if.es esif
);

alu_if aluif ();
npcl_if npclif ();

alu ALU(aluif);
nxt_pc_logic NXT_PC_LOGIC(npclif);

// Track
assign esif.track_out = esif.track_in;

// ALU Input Assignments
assign aluif.ra = esif.in.rdat1;
assign aluif.rb = esif.in.ALUSrc == 1 ? esif.in.extOut : esif.in.rdat2;
assign aluif.aluop = esif.in.ALUOp;

// Nxt PC Logic Input Assignments
assign npclif.j_offset = esif.in.j_offset;
assign npclif.b_offset = esif.in.extOut;
assign npclif.pc = esif.in.pc;

// Outputs to Exec Latch
assign esif.out.halt = esif.in.halt;
assign esif.out.wsel = esif.in.wsel;
assign esif.out.RegWr = esif.in.RegWr;
assign esif.out.MemToReg = esif.in.MemToReg;
assign esif.out.WrLinkReg = esif.in.WrLinkReg;
assign esif.out.MemRd = esif.in.MemRd;
assign esif.out.MemWr = esif.in.MemWr;
assign esif.out.PCSrc = esif.in.PCSrc;
assign esif.out.aluOut = aluif.out;
assign esif.out.zero = aluif.zero;
assign esif.out.rdat1 = esif.in.rdat1;
assign esif.out.rdat2 = esif.in.rdat2;
assign esif.out.b_addr = npclif.b_addr;
assign esif.out.j_addr = npclif.j_addr;
assign esif.out.pc = esif.in.pc;
assign esif.out.pred_taken = esif.in.pred_taken;

endmodule
