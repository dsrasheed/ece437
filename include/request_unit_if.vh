`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface request_unit_if;
  // import types
  import cpu_types_pkg::*;

  logic dREN, dWEN, dready, iready, drreq, dwreq, ireq, stall;

  // request unit device
  modport ru (
    input   dREN, dWEN, dready, iready,
    output  drreq, dwreq, ireq, stall
  );

  // testbench
  modport tb (
    input    drreq, dwreq, ireq, stall,
    output   dREN, dWEN, dready, iready
  );

endinterface

`endif //REQUEST_UNIT_IF_VH
