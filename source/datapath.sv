/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
//`include "fetch_stage.sv"
//`include "fetch_latch.sv"
`include "fetch_stage_if.vh"
`include "fetch_latch_if.vh"
//`include "decode_stage.sv"
//`include "decode_latch.sv"
`include "decode_stage_if.vh"
`include "decode_latch_if.vh"
//`include "exec_stage.sv"
//`include "exec_latch.sv"
`include "exec_stage_if.vh"
`include "exec_latch_if.vh"
//`include "mem_stage.sv"
//`include "mem_latch.sv"
`include "mem_stage_if.vh"
`include "mem_latch_if.vh"
`include "forward_unit_if.vh"
/*`include "request_unit_if.vh"
`include "control_unit_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"
`include "pc_if.vh"
`include "register_file.sv"
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
  word_t mux_out, write_back;
  logic fetch_halt, decode_halt, exec_halt, mem_halt, mem_wait;
  cpu_tracker_t track;

  fetch_latch_if flif ();
  decode_latch_if dlif ();
  exec_latch_if elif ();
  mem_latch_if mlif ();
  fetch_stage_if fsif ();
  decode_stage_if dsif ();
  exec_stage_if esif ();
  mem_stage_if msif ();
  forwarding_unit_if fuif ();

  assign mem_wait = (msif.dcache_dREN | msif.dcache_dWEN) & ~dpif.dhit;

  fetch_stage FSTAGE(CLK, nRST, fsif);
  assign fsif.ihit = dpif.ihit;
  assign fsif.pc_control = msif.pc_control;
  assign fsif.nxt_pc = msif.nxt_pc;
  assign dpif.imemaddr = fsif.out.pc;
  assign dpif.imemREN = 1'b1;
  assign fsif.instr = dpif.imemload;
  assign flif.track_in = fsif.track_out;
  assign flif.in = fsif.out;

  fetch_latch FLATCH(CLK, nRST, flif); 
  assign flif.stall = 1'b0;
  assign flif.flush = ~dpif.ihit | mem_wait;
  
  decode_stage DSTAGE(CLK, nRST, dsif);
  assign dsif.in = flif.out;
  assign dsif.track_in = flif.track_out;
  assign dsif.RegWr = mlif.out.RegWr;
  assign dsif.wsel = mlif.out.wsel;
  assign dsif.wdat = write_back;
  assign dsif.stall = mem_wait;
  assign dlif.track_in = dsif.track_out;
  assign dlif.in = dsif.out;

  decode_latch DLATCH(CLK, nRST, dlif);
  assign dlif.stall = mem_wait;

  exec_stage ESTAGE(esif);
  assign esif.in = dlif.out;
  assign esif.track_in = dlif.track_out;
  assign elif.track_in = esif.track_out;
  assign elif.in = esif.out;

  always_comb
  begin
    esif.in = dlif.out;
    if(fuif.override_rdat1 == 1)
    begin
      esif.in.rdat1 = fuif.new_rdat1;
    end
    if(fuif.override_rdat2 == 1)
    begin
      esif.in.rdat2 = fuif.new_rdat1;
    end
  end

  exec_latch ELATCH(CLK, nRST, elif);
  assign elif.stall = mem_wait;

  mem_stage MSTAGE(msif);
  assign msif.in = elif.out;
  assign msif.track_in = elif.track_out;
  assign dpif.dmemaddr = msif.dcache_daddr;
  assign dpif.dmemstore = msif.dcache_store;
  assign dpif.dmemREN = msif.dcache_dREN;
  assign dpif.dmemWEN = msif.dcache_dWEN;
  assign msif.dmemload = dpif.dmemload;
  assign mlif.track_in = msif.track_out;
  assign mlif.in = msif.out;

  mem_latch MLATCH(CLK, nRST, mlif);
  assign mlif.stall = mem_wait;
 
  assign track.daddr = mlif.track_out.daddr;
  assign track.dstore = mlif.track_out.dstore;
  assign track.nxt_pc = mlif.track_out.nxt_pc;
  assign track.pc = mlif.track_out.pc;
  assign track.instr = mlif.track_out.instr;
  assign track.opcode = mlif.track_out.opcode;
  assign track.funct = mlif.track_out.funct;
  assign track.rs = mlif.track_out.rs;
  assign track.rt = mlif.track_out.rt;
  assign track.wsel = mlif.track_out.wsel;
  assign track.RegWr = mlif.track_out.RegWr;
  assign track.WrLinkReg = mlif.track_out.WrLinkReg;
  assign track.lui = mlif.track_out.lui;
  assign track.shamt = mlif.track_out.shamt;
  assign track.imm = mlif.track_out.imm;
  assign track.branch = mlif.track_out.branch;
  assign track.writeback = write_back;

  always_ff @(posedge CLK, negedge nRST)
  begin
    if(nRST == 0)
    begin
      mem_halt <= 0;
    end
    else if(mlif.out.halt == 1)
    begin
      mem_halt <= 1;
    end
  end
 
  always_ff @(posedge CLK, negedge nRST)
  begin
    if(nRST == 0)
    begin
      dpif.halt <= 0;
    end
    else if(mem_halt == 1)
    begin
      dpif.halt <= 1;
    end
  end
  
  forwarding_unit ONWARD(fuif);
  assign fuif.rs = dlif.out.rs;
  assign fuif.rt = dlif.out.rt;
  assign fuif.mem_wsel = elif.out.wsel;
  assign fuif.wr_wsel = mlif.out.wsel;
  assign fuif.mem_RegWr = elif.out.RegWr;
  assign fuif.wr_RegWr = mlif.out.RegWr;
  assign fuif.writeback = write_back;
  assign fuif.aluOut = elif.out.aluOut;
  
  //Write Back
  always_comb
  begin
    if(mlif.out.MemToReg == 1)
    begin
      mux_out = mlif.out.dmemload;
    end
    else
    begin
      mux_out = mlif.out.aluOut;
    end
    
    if(mlif.out.WrLinkReg == 1)
    begin
      write_back = mlif.out.pc + 4;
    end
    else
    begin
      write_back = mux_out;
    end
  end

  

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
