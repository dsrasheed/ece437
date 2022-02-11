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

  fetch_latch_if flif ();
  decode_latch_if dlif ();
  exec_latch_if elif ();
  mem_latch_if mlif ();
  decode_stage_if dsif ();
  exec_stage_if esif ();
  mem_stage_if msif ();

  fetch_latch(CLK, nRST, flif);

  decode_stage d_stage(CLK, nRST, dsif);
  assign dsif.in = flif.out;
  assign dsif.out = dlif.in;

  decode_latch(CLK, nRST, dlif);

  exec_latch(CLK, nRST, elif);

  mem_latch(CLK, nRST, mlif);

  

  /*// INSTRUCTION ASSIGNMENTS FOR CONVENIENCE
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
  assign cuif.stall = ruif.stall;

  // Request Unit Assignments
  assign ruif.dREN = cuif.MemRd;
  assign ruif.dWEN = cuif.MemWr;
  assign ruif.dready = dpif.dhit;
  assign ruif.iready = dpif.ihit;

  // Cache Assignments
  assign dpif.imemREN = ruif.ireq;
  assign dpif.imemaddr = pcif.iaddr;
  assign dpif.dmemREN = ruif.drreq;
  assign dpif.dmemWEN = ruif.dwreq;
  assign dpif.dmemstore = rfif.rdat2;
  assign dpif.dmemaddr = aluif.out;

  always_ff @ (posedge CLK, negedge nRST)
  begin
      if (nRST == 0)
        dpif.halt <= 0;
      else if (cuif.halt == 1)
        dpif.halt <= 1;
      else
        dpif.halt <= dpif.halt;
  end*/

endmodule
