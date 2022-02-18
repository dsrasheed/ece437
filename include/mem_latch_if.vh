`ifndef MEM_LATCH_IF_VH
`define MEM_LATCH_IF_VH

// typedefs
`include "cpu_types_pkg.vh"
`include "datapath_types_pkg.vh"

interface mem_latch_if;
  // import types
  import cpu_types_pkg::*;
  import datapath_types_pkg::*;

  mem_latch_t in;
  mem_latch_t out;
  cpu_tracker_t track_in, track_out;
  logic stall;

  // mem latch device
  modport ml (
    input   in, track_in, stall,
    output  out, track_out
  );

endinterface

`endif //MEM_LATCH_IF_VH
