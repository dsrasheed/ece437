`include "cpu_types_pkg.vh"
`include "dcache_frame_array_if.vh"

module dcache_frame_array (
  input logic CLK, nRST,
  dcache_frame_array_if.dfa dfaif
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

  if (dfaif.set_valid)
    nxt_frames[dfaif.addr.idx].valid = 1'b1;
  else if (dfaif.clear_valid)
    nxt_frames[dfaif.addr.idx].valid = 1'b0;

  if (dfaif.clear_dirty)
    nxt_frames[dfaif.addr.idx].dirty = 1'b0;
  else if (dfaif.store_data)
    nxt_frames[dfaif.addr.idx].dirty = 1'b1;
  
  if (dfaif.write_tag)
    nxt_frames[dfaif.addr.idx].tag = dfaif.addr.tag;

  if (dfaif.store_data)
    nxt_frames[dfaif.addr.idx].data[dfaif.addr.blkoff] = dfaif.store;

end

assign dfaif.hit = frames[dfaif.addr.idx].tag == dfaif.addr.tag && frames[dfaif.addr.idx].valid;
assign dfaif.out_frame = frames[dfaif.addr.idx];

assign dfaif.hit2 = frames[dfaif.addr2.idx].tag == dfaif.addr2.tag && 
                         frames[dfaif.addr2.idx].valid;
assign dfaif.out_frame2 = frames[dfaif.addr2.idx];

endmodule