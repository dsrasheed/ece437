`ifndef EXEC_LATCH_IF_VH
`define EXEC_LATCH_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface exec_latch_if;
  // import types
  import cpu_types_pkg::*;

  exec_latch_t in;
  exec_latch_t out;
  cpu_tracker_t track_in, track_out;
  logic stall, flush;

  // exec latch device
  modport el (
    input   in, track_in, stall, flush,
    output  out, track_out
  );

endinterface

`endif //EXEC_LATCH_IF_VH
