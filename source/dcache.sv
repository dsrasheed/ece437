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

dcachef_t [1:0] addr, snoopaddr;
logic [1:0] clear_valid, set_valid;
logic [1:0] clear_dirty, set_dirty;
logic [1:0] write_tag;
logic [1:0] wen;
word_t [1:0] wdat;
logic [1:0] hit, snoophit;
dcache_frame [1:0] hitframe, snoopframe;

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
  CHECK_FRAME_DIRTY, FLUSH_WB1, FLUSH_WB2, FLUSHED,
  CHECK_LR,
  CHOOSE_EVICT, EVICT_BUSWB1, EVICT_BUSWB2,
  BUSRD1, BUSRD2,
  BUSRDX1, BUSRDX2,
  QUICK_READ, QUICK_WRITE,
  SNOOP_MISS,
  SNOOP_HIT_M1, SNOOP_HIT_M2,
  SNOOP_HIT_S1, SNOOP_HIT_S2
} dcache_state_t;

logic mem_ready;
dcachef_t dmemaddr;

dcache_state_t state, nxt_state, nxt_snoopstate;

// needed in BUSRDX to determine if it should load or store
logic valid_hitting, nxt_valid_hitting;

logic hitting, nxt_hitting;
logic evicting, nxt_evicting;
logic snooping, nxt_snooping;
logic busrdx_changing;

logic [3:0] flush_counter, nxt_flush_counter;

logic [N_SETS-1:0] LRU, nxt_LRU;

word_t lr, nxt_lr;
logic  lr_valid, nxt_lr_valid;

always_ff @ (posedge CLK, negedge nRST)
begin
  if (nRST == 1'b0) begin
    LRU <= '0;
    state <= IDLE;
    hitting <= 0;
    snooping <= 0;
    evicting <= 0;
    valid_hitting <= 0;
    flush_counter <= '0;
    lr <= '0;
    lr_valid <= 0;
  end
  else begin
    LRU <= nxt_LRU;
    state <= nxt_state;
    hitting <= nxt_hitting;
    snooping <= nxt_snooping;
    evicting <= nxt_evicting;
    valid_hitting <= nxt_valid_hitting;
    flush_counter <= nxt_flush_counter;
    lr <= nxt_lr;
    lr_valid <= nxt_lr_valid;
  end
end

assign dmemaddr = dcif.dmemaddr;
assign mem_ready = ~cif.dwait;

assign snoopaddr = {cif.ccsnoopaddr, cif.ccsnoopaddr};
always_comb
begin
  nxt_snooping = snooping;
  if (state != SNOOP_HIT_M1 && state != SNOOP_HIT_M2 &&
      state != SNOOP_HIT_S1 && state != SNOOP_HIT_S2)
    nxt_snooping = snoophit[0] ? 1'b0 : 1'b1;
end
always_comb
begin
  nxt_snoopstate = SNOOP_MISS;
  if ((snoophit[0] && snoopframe[0].dirty) ||
      (snoophit[1] && snoopframe[1].dirty))
    nxt_snoopstate = SNOOP_HIT_M1;
  else if ((snoophit[0] && !snoopframe[0].dirty) ||
           (snoophit[1] && !snoopframe[1].dirty))
    nxt_snoopstate = SNOOP_HIT_S1;
end

always_comb // State Transitions
begin
  nxt_state = state;
  nxt_hitting = hitting;
  nxt_valid_hitting = valid_hitting;
  nxt_evicting = evicting;
  nxt_flush_counter = flush_counter;
  nxt_lr = lr;
  nxt_lr_valid = lr_valid;
  case (state)
    IDLE:
    begin
      if (cif.ccwait)
        nxt_state = nxt_snoopstate;

      else if (dcif.halt)
        nxt_state = CHECK_FRAME_DIRTY;

      else if (dcif.dmemWEN && dcif.datomic)
        nxt_state = CHECK_LR;

      else if ((hit[0] || hit[1]) && (dcif.dmemWEN || dcif.dmemREN))
      begin
        nxt_hitting = hit[0] ? 0 : 1;
        nxt_valid_hitting = 1'b1;

        if (dcif.dmemWEN && !hitframe[nxt_hitting].dirty)
          nxt_state = BUSRDX1;

        else if (dcif.dmemWEN && hitframe[nxt_hitting].dirty)
          nxt_state = QUICK_WRITE;

        else if (dcif.dmemREN)
          nxt_state = QUICK_READ;
      end

      else if (dcif.dmemWEN || dcif.dmemREN)
          nxt_state = CHOOSE_EVICT;
    end
    CHECK_LR:
    begin
      if (cif.ccwait) nxt_state = nxt_snoopstate;
      else if (lr == dcif.dmemaddr && lr_valid)
      begin
        if (hit[0] || hit[1])
        begin
          nxt_hitting = hit[0] ? 0 : 1;
          nxt_valid_hitting = 1'b1;
          if (hitframe[nxt_hitting].dirty)
            nxt_state = QUICK_WRITE;
          else
            nxt_state = BUSRDX1;
        end
        else
          nxt_state = CHOOSE_EVICT;
      end
      else
        nxt_state = IDLE;
    end
    CHOOSE_EVICT:
    begin
      if (cif.ccwait)
        nxt_state = nxt_snoopstate;
      else
      begin
        if (!hitframe[0].valid)
          nxt_evicting = 1'b0;
        else if (!hitframe[1].valid)
          nxt_evicting = 1'b1;
        else
          nxt_evicting = LRU[dmemaddr.idx];

        if (hitframe[nxt_evicting].dirty)
          nxt_state = EVICT_BUSWB1;

        else if (!hitframe[nxt_evicting].dirty && dcif.dmemREN)
          nxt_state = BUSRD1;

        else if (!hitframe[nxt_evicting].dirty && dcif.dmemWEN)
          nxt_state = BUSRDX1;
      end
    end
    EVICT_BUSWB1:
    begin
      if (cif.ccwait) nxt_state = nxt_snoopstate;
      else if (mem_ready) nxt_state = EVICT_BUSWB2;
    end
    EVICT_BUSWB2:
    begin
      if (mem_ready) nxt_state = IDLE;
    end
    BUSRD1:
    begin
      if (cif.ccwait) nxt_state = nxt_snoopstate;
      else if (mem_ready) nxt_state = BUSRD2;
    end
    BUSRD2:
    begin
      if (mem_ready) 
        nxt_state = IDLE;

      if (dcif.datomic)
      begin
          nxt_lr = dcif.dmemaddr;
          nxt_lr_valid = 1'b1;
      end
    end
    BUSRDX1:
    begin
      if (cif.ccwait)
      begin 
        nxt_state = nxt_snoopstate;
        nxt_valid_hitting = 1'b0;
      end
      else if (mem_ready) nxt_state = BUSRDX2;
    end
    BUSRDX2:
    begin
      if (mem_ready) 
      begin
        nxt_state = IDLE;
        nxt_valid_hitting = 1'b0;
      end
      if (dcif.dmemaddr == lr)
        nxt_lr_valid = 0;
    end
    QUICK_WRITE:
    begin
      if (cif.ccwait) nxt_state = nxt_snoopstate;
      else nxt_state = IDLE;
      nxt_valid_hitting = 1'b0;
      if (dcif.dmemaddr == lr)
        nxt_lr_valid = 0;
    end
    QUICK_READ:
    begin
      if (cif.ccwait) nxt_state = nxt_snoopstate;
      else nxt_state = IDLE;
      nxt_valid_hitting = 1'b0;

      if (dcif.datomic)
      begin
        nxt_lr_valid = 1'b1;
        nxt_lr = dcif.dmemaddr;
      end
    end
    SNOOP_MISS:
    begin
      if (!cif.ccwait) nxt_state = IDLE;
    end
    SNOOP_HIT_M1:
    begin
      if (mem_ready) nxt_state = SNOOP_HIT_M2;
    end
    SNOOP_HIT_S1:
    begin
      if (mem_ready) nxt_state = SNOOP_HIT_S2;
    end
    SNOOP_HIT_M2:
    begin
      if (mem_ready) nxt_state = IDLE;
      if (cif.ccinv && cif.ccsnoopaddr[31:3] == lr[31:3])
        nxt_lr_valid = 1'b0;
    end
    SNOOP_HIT_S2:
    begin
      if (mem_ready) nxt_state = IDLE;
      if (cif.ccinv && cif.ccsnoopaddr[31:3] == lr[31:3])
        nxt_lr_valid = 1'b0;
    end
    CHECK_FRAME_DIRTY:
    begin
      if (cif.ccwait) 
        nxt_state = nxt_snoopstate;
      else if ((flush_counter[0] == 0 && hitframe[0].dirty) ||
               (flush_counter[0] == 1 && hitframe[1].dirty))
      begin
        nxt_state = FLUSH_WB1;
      end
      else if (flush_counter == 4'd15)
        nxt_state = FLUSHED;
      else
        nxt_flush_counter = flush_counter + 1;
    end
    FLUSH_WB1:
    begin
      if (cif.ccwait) nxt_state = nxt_snoopstate;
      else if (mem_ready) nxt_state = FLUSH_WB2;
    end
    FLUSH_WB2:
    begin
      if (mem_ready) nxt_state = IDLE;
    end
    FLUSHED:
    begin
      nxt_lr_valid = 1'b0;
    end
    default:
    begin
      nxt_state = state;
      nxt_hitting = hitting;
      nxt_valid_hitting = valid_hitting;
      nxt_evicting = evicting;
      nxt_flush_counter = flush_counter;
      nxt_lr = lr;
      nxt_lr_valid = lr_valid;
    end
  endcase
end

assign busrdx_changing = valid_hitting ? hitting : evicting;

always_comb // Output Logic
begin
  dcif.dhit = 1'b0;
  dcif.dmemload = '0;
  dcif.flushed = 1'b0;
  cif.dREN = 1'b0;
  cif.dWEN = 1'b0;
  cif.daddr = '0;
  cif.dstore = '0;
  cif.cctrans = 1'b0;
  cif.ccwrite = 1'b0;
  
  addr = {dmemaddr, dmemaddr};
  clear_dirty = '0;
  clear_valid = '0;
  set_valid = '0;
  set_dirty = '0;
  write_tag = '0;
  wen = '0;
  wdat = '0;
  nxt_LRU = LRU;
  case (state)
    CHECK_LR:
    begin
      if (!(lr == dcif.dmemaddr && lr_valid))
      begin
        dcif.dhit = 1'b1;
        dcif.dmemload = '0;
      end
    end
    EVICT_BUSWB1:
    begin
      cif.cctrans = 1'b1;
      cif.dWEN = 1'b1;
      cif.daddr = {hitframe[evicting].tag, dmemaddr.idx, 3'b000};
      cif.dstore = hitframe[evicting].data[0];
    end
    EVICT_BUSWB2:
    begin
      cif.cctrans = 1'b1;
      cif.dWEN = 1'b1;
      cif.daddr = {hitframe[evicting].tag, dmemaddr.idx, 3'b100};
      cif.dstore = hitframe[evicting].data[1];
      if (mem_ready)
      begin
        clear_dirty[evicting] = 1'b1;
        clear_valid[evicting] = 1'b1;
      end
    end
    BUSRD1:
    begin
      cif.cctrans = 1'b1;
      cif.dREN = 1'b1;
      cif.daddr = {dmemaddr.tag, dmemaddr.idx, 3'b000};
      addr[evicting] = cif.daddr;
      if (mem_ready)
      begin
        wen[evicting] = 1'b1;
        wdat[evicting] = cif.dload;
      end
    end
    BUSRD2:
    begin
      cif.cctrans = 1'b1;
      cif.dREN = 1'b1;
      cif.daddr = {dmemaddr.tag, dmemaddr.idx, 3'b100};
      addr[evicting] = cif.daddr;
      if (mem_ready)
      begin
        wen[evicting] = 1'b1;
        wdat[evicting] = cif.dload;

        write_tag[evicting] = 1'b1;
        set_valid[evicting] = 1'b1;
        clear_dirty[evicting] = 1'b1;

        dcif.dhit = 1'b1;
        dcif.dmemload = hitframe[evicting].data[0];
        if (dmemaddr.blkoff == 1'b1)
          dcif.dmemload = cif.dload;

        nxt_LRU[dmemaddr.idx] = ~dmemaddr.blkoff;
      end
    end
    BUSRDX1:
    begin
      cif.cctrans = 1'b1;
      cif.ccwrite = 1'b1;
      cif.dREN = 1'b1;
      cif.daddr = {dmemaddr.tag, dmemaddr.idx, 3'b000};
      addr[busrdx_changing] = cif.daddr;
      if (mem_ready)
      begin
        wen[busrdx_changing] = 1'b1;
        wdat[busrdx_changing] = cif.dload;
        if (dmemaddr.blkoff == 1'b0)
          wdat[busrdx_changing] = dcif.dmemstore;
      end
    end
    BUSRDX2:
    begin
      cif.cctrans = 1'b1;
      cif.ccwrite = 1'b1;
      cif.dREN = 1'b1;
      cif.daddr = {dmemaddr.tag, dmemaddr.idx, 3'b100};
      addr[busrdx_changing] = cif.daddr;
      if (mem_ready)
      begin
        wen[busrdx_changing] = 1'b1;
        wdat[busrdx_changing] = cif.dload;
        if (dmemaddr.blkoff == 1'b1)
          wdat[busrdx_changing] = dcif.dmemstore;

        write_tag[busrdx_changing] = 1'b1;
        set_valid[busrdx_changing] = 1'b1;
        set_dirty[busrdx_changing] = 1'b1;

        dcif.dhit = 1'b1;
        // Only used by SC, ignored by regular SW
        dcif.dmemload = 32'd1;

        nxt_LRU[dmemaddr.idx] = ~dmemaddr.blkoff;
      end
    end
    QUICK_READ:
    begin
      dcif.dhit = 1'b1;
      dcif.dmemload = hitframe[hitting].data[dmemaddr.blkoff];
      nxt_LRU[dmemaddr.idx] = ~dmemaddr.blkoff;
    end
    QUICK_WRITE:
    begin
      wen[hitting] = 1'b1;
      wdat[hitting] = dcif.dmemstore;

      dcif.dhit = 1'b1;
      // Only used by SC, ignored by regular SW
      dcif.dmemload = 32'd1;

      nxt_LRU[dmemaddr.idx] = ~dmemaddr.blkoff;
    end
    SNOOP_HIT_M1:
    begin
      cif.cctrans = 1'b1;
      cif.ccwrite = 1'b1;
      cif.daddr = {snoopaddr[snooping].tag, snoopaddr[snooping].idx, 3'b000};
      cif.dstore = snoopframe[snooping].data[0];
    end
    SNOOP_HIT_M2:
    begin
      cif.cctrans = 1'b1;
      cif.ccwrite = 1'b1;
      cif.daddr =  {snoopaddr[snooping].tag, snoopaddr[snooping].idx, 3'b100};
      cif.dstore = snoopframe[snooping].data[1];
      if (mem_ready)
      begin
        addr[snooping] = cif.daddr;
        clear_dirty[snooping] = 1'b1;
        if (cif.ccinv)
          clear_valid[snooping] = 1'b1;
      end
    end
    SNOOP_HIT_S1:
    begin
      cif.cctrans = 1'b1;
      cif.daddr = {snoopaddr[snooping].tag, snoopaddr[snooping].idx, 3'b000};
      cif.dstore = snoopframe[snooping].data[0];
    end
    SNOOP_HIT_S2:
    begin
      cif.cctrans = 1'b1;
      cif.daddr = {snoopaddr[snooping].tag, snoopaddr[snooping].idx, 3'b100};
      cif.dstore = snoopframe[snooping].data[1];
      if (mem_ready)
      begin
        addr[snooping] = cif.daddr;
        clear_dirty[snooping] = 1'b1;
        if (cif.ccinv)
          clear_valid[snooping] = 1'b1;
      end
    end
    CHECK_FRAME_DIRTY:
    begin
      addr[flush_counter[0]].idx = flush_counter[3:1];
    end
    FLUSH_WB1:
    begin
      cif.cctrans = 1'b1;
      cif.dWEN = 1'b1;
      cif.daddr = {hitframe[flush_counter[0]].tag, flush_counter[3:1], 3'b000};
      cif.dstore = hitframe[flush_counter[0]].data[0];
      addr[flush_counter[0]].idx = flush_counter[3:1];
    end
    FLUSH_WB2:
    begin
      cif.cctrans = 1'b1;
      cif.dWEN = 1'b1;
      cif.daddr = {hitframe[flush_counter[0]].tag, flush_counter[3:1], 3'b100};
      cif.dstore = hitframe[flush_counter[0]].data[1];
      addr[flush_counter[0]].idx = flush_counter[3:1];
      if (mem_ready)
        clear_dirty[flush_counter[0]] = 1'b1;
    end
    FLUSHED:
    begin
      dcif.flushed = 1'b1;

    end
  endcase
end

endmodule
