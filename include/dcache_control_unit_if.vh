`ifndef DCACHE_CONTROL_UNIT_VH
`define DCACHE_CONTROL_UNIT_VH

// typedefs
`include "cpu_types_pkg.vh"

interface dcache_control_unit_if;
  // import types
  import cpu_types_pkg::*;

  // enable
  logic enable;

  // hit counter inputs
  word_t hit_count;

  // cache inputs
  dcache_frame frame0;
  dcache_frame frame1;
  logic frame_sel, hit;

  // datapath inputs
  dcachef_t dmemaddr;
  logic will_modify;
  logic halt;

  // dcache control
  logic load_data, set_valid, clear_dirty,
        write_tag, disable_hit_counter, flushed;
  dcachef_t cache_addr;

  // latch control signals
  logic mem_ready;

  // mem control
  logic dREN, dWEN;
  word_t daddr;
  word_t dstore;
  logic ccwrite, cctrans;

  // decode stage device
  modport dcu (
    input enable, hit_count, frame0, frame1, frame_sel, hit, dmemaddr, halt, 
          mem_ready, will_modify,
    output load_data, set_valid, clear_dirty, write_tag,
           cache_addr, flushed, disable_hit_counter, dREN, dWEN, daddr, dstore,
           ccwrite, cctrans
  );

endinterface

`endif // DCACHE_CONTROL_UNIT_VH
