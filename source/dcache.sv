`include "cpu_types_pkg.vh"
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "dcache_frame_array_if.vh"

module dcache (
  input logic CLK, nRST,
  caches_if.dcache cif,
  datapath_cache_if dcif
);

import cpu_types_pkg::*;

localparam N_SETS = 2**DIDX_W;

logic [1:0] addr, snoopaddr;
logic [1:0] clear_valid, set_valid;
logic [1:0] clear_dirty, set_dirty;
logic [1:0] write_tag;
logic [1:0] wen;
word_t [1:0] wdat;
logic [1:0] hit, snoophit;
dcache_frame [1:0] hitframe, snoopframe;

logic saved_hitno, hitno;
logic saved_evictno, evictno;
logic saved_snoophitno, snoophitno;

dcache_frame_array_if fa0if ();
dcache_frame_array_if fa1if ();
dcache_frame_array FRAME0 (CLK, nRST, fa0if.dfa);
dcache_frame_array FRAME1 (CLK, nRST, fa1if.dfa);

always_comb
begin
  fa0if.addr = addr[0];
  fa0if.snoopaddr = snoopaddr[0];
  fa0if.clear_valid = clear_valid[0];
  fa0if.set_valid = set_valid[0];
  fa0if.clear_dirty = clear_dirty[0];
  fa0if.set_dirty = set_dirty[0];
  fa0if.write_tag = write_tag[0];
  fa0if.wen = wen[0];
  fa0if.wdat = wdat[0];
  hit[0] = fa0if.hit;
  snoophit[0] = fa0if.snoophit;
  hitframe[0] = fa0if.hitframe;
  snoopframe[0] = fa0if.snoopframe;

  fa1if.addr = addr[1];
  fa1if.snoopaddr = snoopaddr[1];
  fa1if.clear_valid = clear_valid[1];
  fa1if.set_valid = set_valid[1];
  fa1if.clear_dirty = clear_dirty[1];
  fa1if.set_dirty = set_dirty[1];
  fa1if.write_tag = write_tag[1];
  fa1if.wen = wen[1];
  fa1if.wdat = wdat[1];
  hit[1] = fa1if.hit;
  snoophit[1] = fa1if.snoophit;
  hitframe[1] = fa1if.hitframe;
  snoopframe[1] = fa1if.snoopframe;
end

typedef enum logic[4:0] {
  IDLE,
  CHECK_FRAME_DIRTY, FLUSH_WB1, FLUSH_WB2, FLUSH_INCR_COUNTER,
  CHOOSE_EVICT, EVICT_WB1, EVICT_WB2, EVICT_UPDATE,
  BUSRD1, BUSRD2, BUSRD_HIT,
  BUSRDX1, BUSRDX2, BUSRDX_HIT,
  QUICK_READ, QUICK_WRITE,
  SNOOP_MISS,
  SNOOP_HIT_S1, SNOOP_HIT_S2,
  SNOOP_HIT_M1, SNOOP_HIT_M2,
  SNOOP_TRANS_I, SNOOP_TRANS_S
} dcache_state_t;

logic mem_ready;
dcache_state_t state, nxt_state;
logic [N_SETS-1:0] LRU, nxt_LRU;

always_ff @ (posedge CLK, negedge nRST)
begin
  if (nRST == 1'b0) begin
    LRU <= '0;
    state <= IDLE;
  end
  else begin
    LRU <= nxt_LRU;
    state <= nxt_state;
  end
end

assign mem_ready = ~cif.dwait;

always_comb
begin

end

endmodule
