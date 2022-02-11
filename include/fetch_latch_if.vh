`ifndef FETCH_LATCH_IF_VH
`define FETCH_LATCH_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface fetch_latch_if;
  // import types
  import cpu_types_pkg::*;

  fetch_latch_t in;
  fetch_latch_t out;
  logic stall;

  // fetch latch device
  modport fl (
    input   in, stall,
    output  out
  );

endinterface

`endif //FETCH_LATCH_IF_VH