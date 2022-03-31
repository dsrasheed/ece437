`ifndef DCACHE_FRAME_ARRAY_IF_VH
`define DCACHE_FRAME_ARRAY_IF_VH

`include "cpu_types_pkg.vh"

interface dcache_frame_array_if;
  // import types
  import cpu_types_pkg::*;
  
  // input
  logic store_data, set_valid, clear_dirty, write_tag;
  dcachef_t addr;
  word_t store;

  // output to control unit
  logic hit;
  dcache_frame out_frame;

  // decode stage device
  modport dfa (
    input store_data, set_valid, clear_dirty, write_tag,
          addr, store,
    output hit, out_frame
  );

endinterface

`endif // DCACHE_FRAME_ARRAY_IF_VH
