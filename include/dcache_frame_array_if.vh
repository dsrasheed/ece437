`ifndef DCACHE_FRAME_ARRAY_IF_VH
`define DCACHE_FRAME_ARRAY_IF_VH

`include "cpu_types_pkg.vh"

interface dcache_frame_array_if;
  // import types
  import cpu_types_pkg::*;
  
  // input
  logic store_data, set_valid, clear_valid, clear_dirty, write_tag;
  dcachef_t addr, addr2;
  word_t store;

  // output to control unit
  logic hit, hit2;
  dcache_frame out_frame, out_frame2;

  // decode stage device
  modport dfa (
    input store_data, set_valid, clear_valid, clear_dirty, write_tag,
          addr, addr2, store,
    output hit, hit2, out_frame, out_frame2
  );

endinterface

`endif // DCACHE_FRAME_ARRAY_IF_VH
