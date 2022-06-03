`ifndef DCACHE_FRAME_ARRAY_IF_VH
`define DCACHE_FRAME_ARRAY_IF_VH

`include "cpu_types_pkg.vh"

interface dcache_frame_array_if;
  // import types
  import cpu_types_pkg::*;
  
  dcachef_t addr, snoopaddr;
  logic clear_valid, set_valid;
  logic clear_dirty, set_dirty;
  logic write_tag;
  logic wen;
  word_t wdat;

  logic hit, snoophit;
  dcache_frame hitframe, snoopframe;

  // dcache frame array
  modport dfa (
    input addr, snoopaddr,
          clear_valid, set_valid,
          clear_dirty, set_dirty,
          write_tag,
          wen,
          wdat,
    output hit, snoophit, 
           hitframe, snoopframe
  );

endinterface

`endif // DCACHE_FRAME_ARRAY_IF_VH
