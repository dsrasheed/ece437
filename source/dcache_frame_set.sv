`include "cpu_types_pkg.vh"
`include "dcache_frame_if.vh"

module dcache_frame_set (
  input logic CLK, nRST,
  dcache_frame_if.df dfif
);

import cpu_types_pkg::*;

localparam N_SETS = 2**DIDX_W;

dcache_frame [N_SETS-1:0] frames;
dcache_frame [N_SETS-1:0] nxt_frames;

always_ff @ (posedge CLK, negedge nRST)
begin
  if (nRST == 1'b0)
    frames <= '0;
  else
    frames <= nxt_frames;
end

always_comb
begin
  nxt_frames = frames;
  if (dfif.latch_en && dfif.replace)
  begin
    if (dfif.load_data)
      nxt_frames[dfif.cache_addr.idx].data[dfif.write_offset] = dfif.dload;
    if (dfif.set_valid)
      nxt_frames[dfif.cache_addr.idx].valid = 1'b1;
    if (dfif.clear_dirty)
      nxt_frames[dfif.cache_addr.idx].dirty = 1'b0;
    if (dfif.write_tag)
      nxt_frames[dfif.cache_addr.idx].tag = dfif.cache_addr.tag;
  end
  else if (dfif.hit && dfif.dmemWEN)
  begin
    nxt_frames[dfif.cache_addr.idx].data[dfif.cache_addr.blkoff] = dfif.dmemstore;
    nxt_frames[dfif.cache_addr.idx].dirty = 1'b1;
  end
end

assign dfif.hit = frames[dfif.cache_addr.idx].tag == dfif.cache_addr.tag;
assign dfif.out_frame = frames[dfif.cache_addr.idx];

endmodule