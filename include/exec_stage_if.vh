`ifndef EXEC_STAGE_IF_VH
`define EXEC_STAGE_IF_VH

// typedefs
`include "cpu_types_pkg.vh"
`include "datapath_types_pkg.vh"

interface exec_stage_if;
  // import types
  import cpu_types_pkg::*;
  import datapath_types_pkg::*;

  decode_latch_t in;
  exec_latch_t out;
  cpu_tracker_t track_in, track_out;

  // exec stage device
  modport es (
    input   in, track_in,
    output  out, track_out
  );

endinterface

`endif //exec_stage
