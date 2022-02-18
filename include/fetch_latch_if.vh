`ifndef FETCH_LATCH_IF_VH
`define FETCH_LATCH_IF_VH

// typedefs
`include "cpu_types_pkg.vh"
`include "datapath_types_pkg.vh"

interface fetch_latch_if;
  // import types
  import cpu_types_pkg::*;
  import datapath_types_pkg::*;

  fetch_latch_t in;
  fetch_latch_t out;
  logic stall, flush;
  cpu_tracker_t track_in, track_out;

  // fetch latch device
  modport fl (
    input   in, track_in, stall, flush
    output  out, track_out
  );

endinterface

`endif //FETCH_LATCH_IF_VH
