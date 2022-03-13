`ifndef DCACHE_CONTROL_UNIT_VH
`define DCACHE_CONTROL_UNIT_VH

// typedefs
`include "cpu_types_pkg.vh"

interface dcache_control_unit_if;
  // import types
  import cpu_types_pkg::*;

  // hit counter inputs
  word_t hit_count;

  // cache inputs
  dcache_frame frame0;
  dcache_frame frame1;
  logic frame_sel, hit;

  // datapath inputs
  dcachef_t dmemaddr;
  logic halt;

  // dcache control
  logic write_offset, load_data, set_valid, clear_dirty,
        write_tag, flushed, decr_counter;
  dcachef_t cache_addr;

  // latch control signals
  logic latch_en;

  // mem control
  logic dREN, dWEN, dwait;
  word_t daddr;
  word_t dstore;

  // decode stage device
  modport dcu (
    input hit_count, frame0, frame1, frame_sel, hit, dmemaddr, halt, dwait,
    output latch_en, write_offset, load_data, set_valid, clear_dirty, write_tag,
           cache_addr, flushed, decr_counter, dREN, dWEN, daddr, dstore
  );

endinterface

`endif // DCACHE_CONTROL_UNIT_VH
