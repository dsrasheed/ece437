`ifndef EXEC_LATCH_IF_VH
`define EXEC_LATCH_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface exec_latch_if;
  // import types
  import cpu_types_pkg::*;

  exec_latch_t in;
  exec_latch_t out;
  logic stall;

  // exec latch device
  modport el (
    input   in, stall,
    output  out
  );

endinterface

`endif //EXEC_LATCH_IF_VH
