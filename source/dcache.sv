`include "cpu_types_pkg.vh"
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "dcache_frame_array_if.vh"
`include "dcache_control_unit_if.vh"

module dcache (
  input logic CLK, nRST,
  caches_if.dcache cif,
  datapath_cache_if dcif
);

import cpu_types_pkg::*;

localparam N_SETS = 2**DIDX_W;

word_t hit_count;
logic mem_ready;
// unused signal connected to HIT_COUNTER's rollover_flag.
// Synthesis screamed at us for having nothing connected to it.
logic discard;
logic [N_SETS-1:0] LRU;
logic [N_SETS-1:0] nxt_LRU;

/* INTERNAL MODULE DECLARATIONS */
dcache_frame_array_if frame0if ();
dcache_frame_array_if frame1if ();
dcache_control_unit_if dcuif ();

dcache_frame_array FRAME0 (CLK, nRST, frame0if.dfa);
dcache_frame_array FRAME1 (CLK, nRST, frame1if.dfa);
dcache_control_unit CONTROL_UNIT (CLK, nRST, dcuif.dcu);
flex_counter #(.NUM_CNT_BITS(32)) HIT_COUNTER (
  .clk(CLK),
  .n_rst(nRST),
  .clear(1'b0),
  .count_enable(dcif.dhit && !dcuif.disable_hit_counter && dcuif.enable),
  .rollover_val(32'hffffffff),
  .count_out(hit_count),
  .rollover_flag(discard)
);

/* GLUEING INTERNAL MODULES TOGETHER */
assign mem_ready = ~cif.dwait;

// control unit input assignments
assign dcuif.enable = dcif.dmemREN | dcif.dmemWEN;
assign dcuif.dmemaddr = dcif.dmemaddr;
assign dcuif.mem_ready = mem_ready;
assign dcuif.frame0 = frame0if.out_frame;
assign dcuif.frame1 = frame1if.out_frame;
assign dcuif.frame_sel = LRU[dcuif.cache_addr.idx];
assign dcuif.hit = dcif.dhit;
assign dcuif.hit_count = hit_count;
assign dcuif.halt = dcif.halt;

// frame 0 input assignments
assign frame0if.addr = dcuif.cache_addr;
always_comb
begin
  frame0if.store_data = 1'b0;
  frame0if.set_valid = 1'b0;
  frame0if.clear_dirty = 1'b0;
  frame0if.write_tag = 1'b0;
  frame0if.store = '0;
  if (frame0if.hit && dcif.dmemWEN)
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
assign frame1if.addr = dcuif.cache_addr;
always_comb
begin
  frame1if.store_data = 1'b0;
  frame1if.set_valid = 1'b0;
  frame1if.clear_dirty = 1'b0;
  frame1if.write_tag = 1'b0;
  frame1if.store = '0;
  if (frame1if.hit && dcif.dmemWEN)
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
assign dcif.dhit = (frame0if.hit | frame1if.hit) & dcuif.enable;
always_comb begin
  dcif.dmemload = frame0if.out_frame.data[dcuif.cache_addr.blkoff];
  if (frame1if.hit)
    dcif.dmemload = frame1if.out_frame.data[dcuif.cache_addr.blkoff];
end
assign dcif.flushed = dcuif.flushed;
// Memory Controller
assign cif.dREN = dcuif.dREN;
assign cif.dWEN = dcuif.dWEN;
assign cif.daddr = dcuif.daddr;
assign cif.dstore = dcuif.dstore;

endmodule
