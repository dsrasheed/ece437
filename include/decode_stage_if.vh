`ifndef DECODE_LATCH_IF_VH
`define DECODE_LATCH_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface decode_latch_if;
  // import types
  import cpu_types_pkg::*;

  fetch_latch_t in;
  decode_latch_t out;
  logic stall;

  // decode latch device
  modport dl (
    input   in, stall,
    output  out
  );

endinterface

`endif //DECODE_LATCH_IF_VH