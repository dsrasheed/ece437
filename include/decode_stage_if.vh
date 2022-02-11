`ifndef DECODE_STAGE_IF_VH
`define DECODE_STAGE_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface decode_stage_if;
  // import types
  import cpu_types_pkg::*;

  fetch_latch_t in;
  logic stall, RegWr;
  logic [REG_W-1:0] wsel;
  word_t wdat;

  decode_latch_t out;

  // decode stage device
  modport ds (
    input   in, stall, RegWr, wsel, wdat,
    output  out
  );

endinterface

`endif //DECODE_STAGE_IF_VH
