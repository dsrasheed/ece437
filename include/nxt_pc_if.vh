`ifndef NPC_IF_VH
`define NPC_IF_VH

// typedefs
`include "cpu_types_pkg.vh"
`include "datapth_types_pkg.vh"

interface nxt_pc_if;
  // import types
  import cpu_types_pkg::*;
  import datapath_types_pkg::*;

  
  pcsrc_t PCSrc;
  logic zero, pc_control;
  word_t nxt_pc, j_addr, b_addr, jr_addr;
  
  // pc device
  modport pc (
    input   PCSrc, j_addr, b_addr, jr_addr, zero,
    output  pc_control, nxt_pc
  );

  // testbench
  modport tb (
    input    pc_control, nxt_pc,
    output   PCSrc, j_addr, b_addr, jr_addr, zero 
  );

endinterface

`endif // NPC_IF_VH
