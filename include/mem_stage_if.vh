`ifndef MEM_STAGE_IF_VH
`define MEM_STAGE_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface mem_stage_if;
  // import types
  import cpu_types_pkg::*;

  exec_latch_t in;
  mem_latch_t out;
  cpu_tracker_t track_in, track_out;

  word_t dcache_store, dcache_daddr, nxt_pc, dmemload;
  logic dcache_dREN, dcache_dWEN, pc_control;

  // mem stage device
  modport ms (
    input   in, track_in, dmemload,
    output  out, track_out, dcache_store, dcache_daddr, dcache_dREN, dcache_dWEN, pc_control, nxt_pc
  );

endinterface

`endif //mem_stage
