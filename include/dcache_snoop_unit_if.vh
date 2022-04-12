`ifndef DCACHE_SNOOP_UNIT_VH
`define DCACHE_SNOOP_UNIT_VH

// typedefs
`include "cpu_types_pkg.vh"

interface dcache_snoop_unit_if;
  // import types
  import cpu_types_pkg::*;

  // Frame Array Snooping
  logic snoop_hit;
  dcache_frame snoop_frame;

  // Snooping Control Signals
  logic ccwait, cctrans, ccwrite, ccinv;
  dcachef_t ccsnoopaddr;

  // Frame Array Control
  logic clear_dirty, clear_valid;

  // Memory Controller Output
  word_t daddr, dstore;
  logic mem_ready;

  // dcache snoop unit device
  modport dsu (
    input snoop_hit, snoop_frame, ccwait, ccinv, ccsnoopaddr, mem_ready,
    output cctrans, ccwrite, clear_dirty, clear_valid, daddr, dstore
  );

endinterface

`endif // DCACHE_SNOOP_UNIT_VH
