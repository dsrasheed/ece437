`ifndef MEM_STAGE_IF_VH
`define MEM_STAGE_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface mem_stage_if;
  // import types
  import cpu_types_pkg::*;

  exec_latch_t in;
  mem_latch_t out;

  word_t dcache_store, dcache_daddr;
  logic dcache_dREN, dcache_dWEN;

  // mem stage device
  modport ms (
    input   in,
    output  out, dcache_store, dcache_daddr, dcache_dREN, dcache_dWEN
  );

endinterface

`endif //mem_stage
