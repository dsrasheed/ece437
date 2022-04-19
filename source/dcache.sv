`include "cpu_types_pkg.vh"
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "dcache_frame_array_if.vh"
`include "dcache_control_unit_if.vh"
`include "dcache_snoop_unit_if.vh"

module dcache (
  input logic CLK, nRST,
  caches_if.dcache cif,
  datapath_cache_if dcif
);

import cpu_types_pkg::*;

localparam N_SETS = 2**DIDX_W;

//word_t hit_count;
logic mem_ready;
// unused signal connected to HIT_COUNTER's rollover_flag.
// Synthesis screamed at us for having nothing connected to it.
//logic discard;
logic [N_SETS-1:0] LRU;
logic [N_SETS-1:0] nxt_LRU;

/* INTERNAL MODULE DECLARATIONS */
dcache_frame_array_if frame0if ();
dcache_frame_array_if frame1if ();
dcache_control_unit_if dcuif ();
dcache_snoop_unit_if dsuif ();

dcache_frame_array FRAME0 (CLK, nRST, frame0if.dfa);
dcache_frame_array FRAME1 (CLK, nRST, frame1if.dfa);
dcache_control_unit CONTROL_UNIT (CLK, nRST, dcuif.dcu);
dcache_snoop_unit SNOOP_UNIT (CLK, nRST, dsuif.dsu);
/*flex_counter #(.NUM_CNT_BITS(32)) HIT_COUNTER (
  .clk(CLK),
  .n_rst(nRST),
  .clear(1'b0),
  .count_enable(dcif.dhit && !dcuif.disable_hit_counter && dcuif.enable),
  .rollover_val(32'hffffffff),
  .count_out(hit_count),
  .rollover_flag(discard)
);*/

/* GLUEING INTERNAL MODULES TOGETHER */
assign mem_ready = ~cif.dwait;

// control unit input assignments
assign dcuif.enable = (dcif.dmemREN | dcif.dmemWEN);
assign dcuif.dmemaddr = dcif.dmemaddr;
assign dcuif.will_modify = dcif.dmemWEN;
assign dcuif.mem_ready = mem_ready & ~dsuif.pr_stall;
assign dcuif.frame0 = frame0if.out_frame;
assign dcuif.frame1 = frame1if.out_frame;
assign dcuif.frame_sel = LRU[dcuif.cache_addr.idx];
assign dcuif.hit = (frame0if.hit | frame1if.hit) & dcuif.enable;
assign dcuif.hit0 = frame0if.hit && dcuif.enable;
assign dcuif.hit1 = frame1if.hit && dcuif.enable;
//assign dcuif.hit_count = hit_count;
assign dcuif.halt = dcif.halt;

// frame 0 input assignments
assign frame0if.addr2 = cif.ccsnoopaddr;
always_comb
begin
  frame0if.store_data = 1'b0;
  frame0if.set_valid = 1'b0;
  frame0if.clear_valid = 1'b0;
  frame0if.clear_dirty = 1'b0;
  frame0if.write_tag = 1'b0;
  frame0if.store = '0;
  frame0if.addr = dcuif.cache_addr;
  if (dsuif.pr_stall)
  begin
    frame0if.addr = cif.ccsnoopaddr;
    frame0if.clear_valid = frame0if.hit2 && dsuif.clear_valid;
    frame0if.clear_dirty = frame0if.hit2 && dsuif.clear_dirty;
  end
  else if (dcuif.halt_frame0_ctrl)
  begin
      frame0if.clear_dirty = dcuif.clear_dirty;
  end
  else if (frame0if.hit && dcif.dmemWEN && !frame0if.out_frame.dirty && dcuif.inv_complete)
  begin
    frame0if.store_data = 1'b1;
    frame0if.store = dcif.dmemstore;
  end
  else if (mem_ready && LRU[dcuif.cache_addr.idx] == 1'b0)
  begin
    frame0if.store_data = dcuif.load_data;
    frame0if.set_valid = dcuif.set_valid;
    frame0if.clear_dirty = dcuif.clear_dirty;
    frame0if.write_tag = dcuif.write_tag;
    frame0if.store = cif.dload;
  end
end

// frame 1 input assignments
assign frame1if.addr2 = cif.ccsnoopaddr;
always_comb
begin
  frame1if.store_data = 1'b0;
  frame1if.set_valid = 1'b0;
  frame1if.clear_valid = 1'b0;
  frame1if.clear_dirty = 1'b0;
  frame1if.write_tag = 1'b0;
  frame1if.store = '0;
  frame1if.addr = dcuif.cache_addr;
  if (dsuif.pr_stall)
  begin
    frame1if.addr = cif.ccsnoopaddr;
    frame1if.clear_valid = frame1if.hit2 && dsuif.clear_valid;
    frame1if.clear_dirty = frame1if.hit2 && dsuif.clear_dirty;
  end
  else if (dcuif.halt_frame1_ctrl)
  begin
      frame1if.clear_dirty = dcuif.clear_dirty;
  end
  else if (frame1if.hit && dcif.dmemWEN && !frame1if.out_frame.dirty && dcuif.inv_complete)
  begin
    frame1if.store_data = 1'b1;
    frame1if.store = dcif.dmemstore;
  end
  else if (mem_ready && LRU[dcuif.cache_addr.idx] == 1'b1)
  begin
    frame1if.store_data = dcuif.load_data;
    frame1if.set_valid = dcuif.set_valid;
    frame1if.clear_dirty = dcuif.clear_dirty;
    frame1if.write_tag = dcuif.write_tag;
    frame1if.store = cif.dload;
  end
end

// Snoop Control Input Assignments
assign dsuif.ccwait = cif.ccwait;
assign dsuif.ccinv = cif.ccinv;
assign dsuif.ccsnoopaddr = cif.ccsnoopaddr;
assign dsuif.snoop_hit = frame0if.hit2 | frame1if.hit2;
assign dsuif.snoop_frame = frame0if.hit2 ? frame0if.out_frame2 : frame1if.out_frame2;
assign dsuif.mem_ready = mem_ready;

/* LRU Logic */
always_ff @ (posedge CLK, negedge nRST)
begin
  if (nRST == 1'b0)
    LRU <= '0;
  else
    LRU <= nxt_LRU;
end

always_comb
begin
  nxt_LRU = LRU;
  if (frame0if.hit && dcuif.enable)
    nxt_LRU[dcuif.cache_addr.idx] = 1'b1;
  else if (frame1if.hit && dcuif.enable)
    nxt_LRU[dcuif.cache_addr.idx] = 1'b0;
end

/* OUTPUTS */
// Datapath
always_comb begin
  dcif.dhit = 1'b0;
  dcif.dmemload = '0;
  if (frame0if.hit)
  begin
    dcif.dhit = ((~frame0if.out_frame.dirty | dcuif.inv_complete) & dcuif.will_modify) ? 1'b0 : dcuif.hit;
    dcif.dmemload = frame0if.out_frame.data[dcuif.cache_addr.blkoff];
  end
  else if (frame1if.hit)
  begin
    dcif.dhit = ((~frame1if.out_frame.dirty | dcuif.inv_complete) & dcuif.will_modify) ? 1'b0 : dcuif.hit;
    dcif.dmemload = frame1if.out_frame.data[dcuif.cache_addr.blkoff];
  end
end
assign dcif.flushed = dcuif.flushed;
// Memory Controller
assign cif.dREN = dcuif.dREN;
assign cif.dWEN = dcuif.dWEN;
always_comb begin
  cif.daddr = dcuif.daddr;
  cif.dstore = dcuif.dstore;
  cif.cctrans = dcuif.cctrans;
  cif.ccwrite = dcuif.ccwrite;
  if (dsuif.pr_stall) begin
    cif.daddr = dsuif.daddr;
    cif.dstore = dsuif.dstore;
    cif.cctrans = dsuif.cctrans;
    cif.ccwrite = dsuif.ccwrite;
  end
end

endmodule
