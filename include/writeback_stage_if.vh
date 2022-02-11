`ifndef WRITEBACK_STAGE_IF_VH
`define WRITEBACK_STAGE_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface writeback_stage_if;
  // import types
  import cpu_types_pkg::*;

  word_t out;
  logic MemToReg;
  word_t nxt_pc, imemaddr, imemload;

  // decode stage device
  modport wbs (
    input   stall, imemload, ihit, pc_control, nxt_pc,
    output  out, imemaddr
  );

endinterface

`endif //WRITEBACK_STAGE_IF_VH
