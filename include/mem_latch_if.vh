`ifndef MEM_LATCH_IF_VH
`define MEM_LATCH_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface mem_latch_if;
  // import types
  import cpu_types_pkg::*;

  mem_latch_t in;
  mem_latch_t out;
  logic stall;

  // mem latch device
  modport ml (
    input   in, stall,
    output  out
  );

endinterface

`endif //MEM_LATCH_IF_VH
