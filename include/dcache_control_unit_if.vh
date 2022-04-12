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
  logic frame_sel, hit, hit0, hit1;

  // datapath inputs
  dcachef_t dmemaddr;
  logic will_modify;
  logic halt;

  // dcache control
  logic load_data, set_valid, clear_dirty,
        write_tag, flushed;
  dcachef_t cache_addr;
  logic halt_frame0_ctrl, halt_frame1_ctrl, inv_complete;

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
          mem_ready, will_modify, hit0, hit1,
    output load_data, set_valid, clear_dirty, write_tag,
           cache_addr, flushed, dREN, dWEN, daddr, dstore,
           ccwrite, cctrans, halt_frame0_ctrl, halt_frame1_ctrl, inv_complete
  );

endinterface

`endif // DCACHE_CONTROL_UNIT_VH
