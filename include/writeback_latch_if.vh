`ifndef WRITEBACK_LATCH_IF_VH
`define WRITEBACK_LATCH_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface writeback_latch_if;
  // import types
  import cpu_types_pkg::*;

  writeback_latch_t in;
  writeback_latch_t out;
  logic stall;

  // fetch latch device
  modport wbl (
    input   in, stall,
    output  out
  );

endinterface

`endif //WRITEBACK_LATCH_IF_VH
