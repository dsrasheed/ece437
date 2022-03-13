`include "cpu_types_pkg.vh"
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "dcache_frame_if.vh"
`include "dcache_control_unit_if.vh"

module dcache (
  input logic CLK, nRST,
  caches_if.dcache cif,
  datapath_cache_if.dcache dcif
);

import cpu_types_pkg::*;

localparam N_SETS = 2**DIDX_W;

/* GLUE SIGNALS */
word_t hit_count;
logic hit;

/* LRU */
logic [N_SETS-1:0] LRU;
logic [N_SETS-1:0] nxt_LRU;

dcache_frame_if frame0if ();
dcache_frame_if frame1if ();
dcache_control_unit_if dcuif ();

dcache_frame_set FRAME0 (CLK, nRST, frame0if.df);
dcache_frame_set FRAME1 (CLK, nRST, frame1if.df);
dcache_control_unit CONTROL_UNIT (CLK, nRST, dcuif.dcu);
flex_counter #(.NUM_CNT_BITS(32)) HIT_COUNTER (
  .clk(CLK),
  .n_rst(nRST),
  .clear(1'b0),
  .count_enable(hit),
  .rollover_val(32'hffffffff),
  .count_out(hit_count)
);

// glue logic assignments
assign hit = frame0if.hit | frame1if.hit;

// control unit input assignments
assign dcuif.hit_count = hit_count;
assign dcuif.frame0 = frame0if.out_frame;
assign dcuif.frame1 = frame1if.out_frame;
assign dcuif.frame_sel = LRU[dcuif.cache_addr.idx];
assign dcuif.hit = hit;
assign dcuif.dmemaddr = dcif.dmemaddr;
assign dcuif.halt = dcif.halt;
assign dcuif.dwait = cif.dwait;

// datapath input assignments
assign dcif.flushed = dcuif.flushed;

// memory control input assignments
assign cif.dREN = dcuif.dREN;
assign cif.dWEN = dcuif.dWEN;
assign cif.daddr = dcuif.daddr;
assign cif.dstore = dcuif.dstore;

// frame 0 input assignments
assign frame0if.write_offset = dcuif.write_offset;
assign frame0if.load_data = dcuif.load_data;
assign frame0if.set_valid = dcuif.set_valid;
assign frame0if.clear_dirty = dcuif.clear_dirty;
assign frame0if.write_tag = dcuif.write_tag;
assign frame0if.latch_en = dcuif.latch_en;
assign frame0if.cache_addr = dcuif.cache_addr;
assign frame0if.dload = cif.dload;
assign frame0if.replace = LRU[dcuif.cache_addr.idx] == 1'b0;
assign frame0if.dmemstore = dcif.dmemstore;
assign frame0if.dmemWEN = dcif.dmemWEN;

// frame 1 input assignments
assign frame1if.write_offset = dcuif.write_offset;
assign frame1if.load_data = dcuif.load_data;
assign frame1if.set_valid = dcuif.set_valid;
assign frame1if.clear_dirty = dcuif.clear_dirty;
assign frame1if.write_tag = dcuif.write_tag;
assign frame1if.latch_en = dcuif.latch_en;
assign frame1if.cache_addr = dcuif.cache_addr;
assign frame1if.dload = cif.dload;
assign frame1if.replace = LRU[dcuif.cache_addr.idx] == 1'b1;
assign frame1if.dmemstore = dcif.dmemstore;
assign frame1if.dmemWEN = dcif.dmemWEN;

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
  if (frame0if.hit)
    nxt_LRU[dcuif.cache_addr.idx] = 1'b1;
  else if (frame1if.hit)
    nxt_LRU[dcuif.cache_addr.idx] = 1'b0;
end

endmodule