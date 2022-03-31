`ifndef DECODE_STAGE_IF_VH
`define DECODE_STAGE_IF_VH

// typedefs
`include "cpu_types_pkg.vh"
`include "datapath_types_pkg.vh"

interface decode_stage_if;
  // import types
  import cpu_types_pkg::*;
  import datapath_types_pkg::*;

  fetch_latch_t in;
  cpu_tracker_t track_in, track_out;
  logic stall, RegWr, pred_taken;
  pcsrc_t PCSrc;
  logic [REG_W-1:0] wsel;
  word_t wdat;

  decode_latch_t out;

  // decode stage device
  modport ds (
    input   in, track_in, stall, RegWr, wsel, wdat, pred_taken,
    output  out, track_out, PCSrc
  );

endinterface

`endif //DECODE_STAGE_IF_VH
