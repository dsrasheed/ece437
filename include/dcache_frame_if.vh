`ifndef DCACHE_FRAME_IF_VH
`define DCACHE_FRAME_IF_VH

`include "cpu_types_pkg.vh"

interface dcache_frame_if;
  // import types
  import cpu_types_pkg::*;

  // input from RAM
  word_t dload;

  // input from datapath
  word_t dmemstore;
  logic dmemWEN;

  // output to control unit
  logic hit;
  dcache_frame out_frame;
  
  // input from control unit
  logic write_offset, load_data, set_valid, clear_dirty, write_tag, latch_en;
  dcachef_t cache_addr;

  // input from LRU
  logic replace;

  // decode stage device
  modport df (
    input write_offset, load_data, set_valid, clear_dirty, write_tag,
          latch_en, cache_addr, dload, replace, dmemstore, dmemWEN,
    output hit, out_frame
  );

endinterface

`endif // DCACHE_FRAME_IF_VH
