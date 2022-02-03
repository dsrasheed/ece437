/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "request_unit_if.vh"
`include "control_unit_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"
`include "pc_if.vh"
/*`include "register_file.sv"
`include "alu.sv"*/

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

  request_unit_if rqif ();
  control_unit_if cuif ();
  pc_if pcif ();
  register_file_if rfif ();
  alu_if aluif ();

  request_unit req_unit(CLK, nRST, rqif.ru);
  pc #(.PC_INIT(PC_INIT)) PC(CLK, nRST, pcif.pc);
  control_unit ctrl_unit(cuif.cu);
  register_file reg_file(CLK, nRST, rfif.rf);
  alu ALU(aluif.alu);

  // GLUE WIRES
  r_t rinstr;
  i_t iinstr;
  j_t jinstr;
  word_t extOut;
  word_t imm_value;

  // INSTRUCTION ASSIGNMENTS FOR CONVENIENCE
  always_comb begin
    rinstr = dpif.imemload;
    iinstr = dpif.imemload;
    jinstr = dpif.imemload;
  end

  // EXTENDER BLOCK
  always_comb begin
    extOut = {'0, iinstr.imm};
    if (cuif.ExtOp == 1 && iinstr.imm[IMM_W-1] == 1)
        extOut = {16'hffff, iinstr.imm};
  end

  // UPPER SHIFT BLOCK
  always_comb begin
    imm_value = extOut;
    if (cuif.ShiftUp == 1)
      imm_value = {extOut[IMM_W-1:0], 16'h0};
  end

  // ALU Input Assignments
  assign aluif.ra = rfif.rdat1;
  assign aluif.rb = cuif.ALUSrc == 1 ? imm_value : rfif.rdat2;
  assign aluif.aluop = cuif.ALUOp;

  // Register File Assignments
  assign rfif.WEN = cuif.RegWr;
  assign rfif.wsel = cuif.WrLinkReg == 1 ? 31 :
                     cuif.RegDst == 1 ? rinstr.rd : rinstr.rt;
  assign rfif.rsel1 = rinstr.rs;
  assign rfif.rsel2 = rinstr.rt;
  always_comb begin
    rfif.wdat = aluif.out;
    if (cuif.WrLinkReg)
      rfif.wdat = pcif.iaddr + 4;
    else if (cuif.MemToReg)
      rfif.wdat = dpif.dmemload;
  end

  // PC Assignments
  assign pcif.PCSrc = cuif.PCSrc;
  assign pcif.j_offset = jinstr.addr;
  assign pcif.b_offset = extOut << 2;
  assign pcif.jr_addr  = rfif.rdat1;

  // Control Unit Assignments
  assign cuif.opcode = rinstr.opcode;
  assign cuif.funct = rinstr.funct;
  assign cuif.equal = aluif.zero;
  assign cuif.stall = rqif.stall;

  // Request Unit Assignments
  assign rqif.dREN = cuif.MemRd;
  assign rqif.dWEN = cuif.MemWr;
  assign rqif.dready = dpif.dhit;
  assign rqif.iready = dpif.ihit;

  // Cache Assignments
  assign dpif.halt = cuif.halt;
  assign dpif.imemREN = rqif.ireq;
  assign dpif.imemaddr = pcif.iaddr;
  assign dpif.dmemREN = rqif.drreq;
  assign dpif.dmemWEN = rqif.dwreq;
  assign dpif.dmemstore = rfif.rdat2;
  assign dpif.dmemaddr = aluif.out;

endmodule
