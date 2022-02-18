`ifndef DECODE_LATCH_IF_VH
`define DECODE_LATCH_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface decode_latch_if;
  // import types
  import cpu_types_pkg::*;

  decode_latch_t in;
  decode_latch_t out;
  cpu_tracker_t track_in, track_out;
  logic stall, flush;

  // decode latch device
  modport dl (
    input   in, track_in, stall, flush,
    output  out, track_out
  );

endinterface

`endif //DECODE_LATCH_IF_VH
